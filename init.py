import sys
import shutil

from datetime import datetime
from pathlib import Path

now = datetime.now()
now_str = now.strftime("%H:%M:%S %B %d, %Y")

project_path = Path(sys.argv[1])

project_name = project_path.name

try:
    project_path.mkdir()
except:
    pass

def copy_template_file(f, g):
    text = f.read()

    text = (
        text
            .replace("%DATE%", now_str)
            .replace("%PROJECT%", project_name)
    )

    g.write(text)

sample_path = Path("sample")

with open(sample_path / "project.qpf") as f, open(project_path / f"{project_name}.qpf", "w") as g:
    copy_template_file(f, g)

with open(sample_path / "project.qsf") as f, open(project_path / f"{project_name}.qsf", "w") as g:
    copy_template_file(f, g)

shutil.copy(sample_path / "Makefile", project_path)
shutil.copy(sample_path / "main.vhdl", project_path)
