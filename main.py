import argparse
import os
import subprocess
import tempfile


def md_file_type(filename: str) -> str:
    if not filename.endswith(".lsh.md"):
        raise argparse.ArgumentTypeError(f"File '{filename}' does not end with .lsh.md")
    if not os.path.isfile(filename):
        raise argparse.ArgumentTypeError(f"File '{filename}' does not exist")
    return filename


parser = argparse.ArgumentParser(description="Process a single literate markdown file.")
_ = parser.add_argument(
    "input_file",
    type=md_file_type,
    help="Literate Markdown file, ending in .lsh.md",
)

args = parser.parse_args()

with open(args.input_file, "r") as f:  # pyright: ignore[reportAny]
    lines = f.readlines()


is_in_code_block: bool = False
bash_lines: list[str] = []

for line in lines:
    if line.startswith("```bash"):
        is_in_code_block = True
        continue

    if line.startswith("```"):
        bash_lines.append("\n")
        is_in_code_block = False
        continue

    if is_in_code_block:
        bash_lines.append(line)


with tempfile.NamedTemporaryFile("w+", suffix=".sh", delete=True) as tmp:
    tmp.writelines(bash_lines)
    tmp.flush()
    _ = tmp.seek(0)
    _ = subprocess.run(["bash"], stdin=tmp)
