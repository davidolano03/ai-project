"""Package the student's original photographs without retouching.

Run: python hand/build_appendix.py
Requires reportlab (python -m pip install reportlab).
"""
from pathlib import Path
from reportlab.lib.pagesizes import A4
from reportlab.lib.utils import ImageReader
from reportlab.pdfgen import canvas

ROOT = Path(__file__).resolve().parent
PAGES = [
    ("01-bayes-definicion.jpg", "1. Bayes: definición y preparación"),
    ("02-bayes-desarrollo.jpg", "2. Bayes: posterior, media y varianza"),
    ("03-varianzas.jpg", "3. Pronóstico público y derivación de varianzas"),
]


def main():
    output = ROOT / "derivaciones-manuscritas.pdf"
    pdf = canvas.Canvas(str(output), pagesize=A4, pageCompression=1)
    pdf.setTitle("Derivaciones manuscritas: Bayes y varianzas")
    pdf.setAuthor("David Julio Olano Silva Nevado")
    width, height = A4
    margin = 28
    for index, (name, title) in enumerate(PAGES, 1):
        pdf.setFont("Helvetica-Bold", 13)
        pdf.drawString(margin, height - 29, title)
        pdf.setFont("Helvetica", 9)
        pdf.drawString(margin, height - 44,
                       "Fotografía original proporcionada por el estudiante")
        photograph = ImageReader(str(ROOT / name))
        iw, ih = photograph.getSize()
        bottom, top = 33, height - 58
        scale = min((width - 2 * margin) / iw, (top - bottom) / ih)
        dw, dh = iw * scale, ih * scale
        pdf.drawImage(photograph, (width - dw) / 2,
                      bottom + (top - bottom - dh) / 2, width=dw, height=dh)
        pdf.setFont("Helvetica", 9)
        pdf.drawCentredString(width / 2, 16, f"{index} / {len(PAGES)}")
        pdf.showPage()
    pdf.save()
    print(output)


if __name__ == "__main__":
    main()
