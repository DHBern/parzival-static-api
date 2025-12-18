#!/usr/bin/env python3

import re
import sys
import shutil
import subprocess
from pathlib import Path
from datetime import datetime

import pikepdf
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.colors import Color


OLD_URL_RE = re.compile(
    r"http://www\.parzival\.unibe\.ch/parzdb/parzival\.php\?page=fassungen&dreissiger=(\d+)"
)

NEW_URL_TEMPLATE = "https://dhbern.github.io/presentation_parzival/fassungen/{n}"

def add_metadata(pdf_path: Path):
    with pikepdf.Pdf.open(pdf_path, allow_overwriting_input=True) as pdf:
        info = pdf.docinfo

        # Core descriptive metadata (empty by design)
        info["/Title"] = ""
        info["/Author"] = ""
        info["/Subject"] = ""
        info["/Keywords"] = ""
        info["/Creator"] = ""
        info["/Producer"] = ""
        info["/Rights"] = ""
        info["/Description"] = ""

        # Dates: PDF date string (D:YYYYMMDDHHmmSS)
        now = datetime.now()
        pdf_date = now.strftime("D:%Y%m%d%H%M%S")

        info["/CreationDate"] = pdf_date
        info["/ModDate"] = pdf_date

        pdf.save(pdf_path)


def extract_trailing_number(path: Path) -> int:
    """
    Extract the trailing integer from a filename.
    Example: mon12.pdf -> 12
    """
    m = re.search(r"(\d+)(?=\.pdf$)", path.name)
    if not m:
        raise ValueError(f"No trailing number found in filename: {path.name}")
    return int(m.group(1))


def collect_and_sort_pdfs(input_dir: Path) -> list[Path]:
    pdfs = list(input_dir.glob("*.pdf"))
    if not pdfs:
        raise RuntimeError("No PDF files found in input directory")

    try:
        return sorted(pdfs, key=extract_trailing_number)
    except ValueError as e:
        raise RuntimeError(str(e))


def merge_pdfs(paths: list[Path], out_path: Path):
    merged = pikepdf.Pdf.new()
    for p in paths:
        with pikepdf.Pdf.open(p) as pdf:
            merged.pages.extend(pdf.pages)
    merged.save(out_path)


def rewrite_links(pdf_path: Path):
    with pikepdf.Pdf.open(pdf_path, allow_overwriting_input=True) as pdf:
        for page in pdf.pages:
            annots = page.get("/Annots", [])
            for annot in annots:
                if annot.get("/Subtype") != "/Link":
                    continue
                action = annot.get("/A")
                if not action:
                    continue
                uri = action.get("/URI")
                if not uri:
                    continue

                uri_str = str(uri)
                m = OLD_URL_RE.search(uri_str)
                if m:
                    n = m.group(1)
                    action["/URI"] = NEW_URL_TEMPLATE.format(n=n)

        pdf.save(pdf_path)


def normalize_to_a4(in_path: Path, out_path: Path):
    """
    Scale pages to fit A4, preserve orientation, center content.
    """
    cmd = [
        "gs",
        "-dSAFER",
        "-dBATCH",
        "-dNOPAUSE",
        "-sDEVICE=pdfwrite",
        "-dPDFFitPage",
        "-sPAPERSIZE=a4",
        f"-sOutputFile={out_path}",
        str(in_path),
    ]
    subprocess.run(cmd, check=True)


def create_footer_pdf(out_path: Path, year: int):
    """
    Create a single-page A4 PDF containing the footer text.
    """
    c = canvas.Canvas(str(out_path), pagesize=A4)
    width, height = A4

    footer_text = f"© Parzival-Projekt, Universität Bern, {year}"

    grey = Color(0.6, 0.6, 0.6)  # light grey
    c.setFillColor(grey)
    c.setFont("Helvetica", 8)

    c.drawCentredString(width / 2, 15 * 72 / 25.4, footer_text)
    c.showPage()
    c.save()


def stamp_footer(pdf_path: Path, footer_path: Path, out_path: Path):
    with pikepdf.Pdf.open(pdf_path) as base_pdf, pikepdf.Pdf.open(footer_path) as footer_pdf:
        footer_page = footer_pdf.pages[0]
        for page in base_pdf.pages:
            page.add_overlay(footer_page)
        base_pdf.save(out_path)


def main():
    if len(sys.argv) not in (2, 3):
        print(
            "Usage: merge_monopsis_pdf.py <input-directory> [output-pdf]",
            file=sys.stderr,
        )
        sys.exit(1)

    input_dir = Path(sys.argv[1])

    if len(sys.argv) == 3:
        final_pdf = Path(sys.argv[2])
    else:
        final_pdf = Path("eintextedition.pdf")

    if not input_dir.is_dir():
        print("Input path is not a directory", file=sys.stderr)
        sys.exit(1)

    work_dir = input_dir / ".work"
    work_dir.mkdir(exist_ok=True)

    merged_pdf = work_dir / "merged.pdf"
    a4_pdf = work_dir / "a4.pdf"
    footer_pdf = work_dir / "footer.pdf"

    print("Collecting and sorting PDFs…")
    pdfs = collect_and_sort_pdfs(input_dir)

    print("Merging PDFs…")
    merge_pdfs(pdfs, merged_pdf)

    print("Rewriting links…")
    rewrite_links(merged_pdf)

    print("Normalizing page size to A4…")
    normalize_to_a4(merged_pdf, a4_pdf)

    print("Creating footer…")
    year = datetime.now().year
    create_footer_pdf(footer_pdf, year)

    print("Stamping footer…")
    stamp_footer(a4_pdf, footer_pdf, final_pdf)

    print("Adding metadata…")
    add_metadata(final_pdf)

    print(f"Done. Output written to {final_pdf}")


if __name__ == "__main__":
    main()
