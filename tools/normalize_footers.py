#!/usr/bin/env python3
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

EMAIL = 'contact@jolkhabarstore.com'

def process_file(path: Path):
    text = path.read_text(encoding='utf-8')
    orig = text

    # Normalize mailto hrefs to lowercase target
    text = re.sub(r'href=("|\')mailto:[^"\']*("|\')', lambda m: f'href="mailto:{EMAIL}"', text, flags=re.IGNORECASE)

    # Replace any visible email occurrences with a span.footer-email
    text = re.sub(r'(?i)\bcontact@jolkhabarstore\.com\b', f'<span class="footer-email">{EMAIL}</span>', text)

    # Normalize 'All rights reserved.' to sentence-case inside a span.rights
    # Replace any case-variant occurrences
    def rights_repl(m):
        return '<span class="rights">All rights reserved.</span>'

    text = re.sub(r'(?i)All\s+Rights\s+Reserved\.?', rights_repl, text)

    # If the file changed, backup and write
    if text != orig:
        bak = path.with_suffix(path.suffix + '.bak')
        if not bak.exists():
            bak.write_text(orig, encoding='utf-8')
        path.write_text(text, encoding='utf-8')
        return True
    return False

def main():
    modified = []
    for root, dirs, files in os.walk(ROOT):
        # skip node_modules or .git if present
        dirs[:] = [d for d in dirs if d not in ('.git', 'node_modules', '__pycache__')]
        for fname in files:
            if not fname.lower().endswith('.html'):
                continue
            if fname.lower().endswith('.html.bak'):
                continue
            path = Path(root) / fname
            try:
                if process_file(path):
                    modified.append(str(path.relative_to(ROOT)))
            except Exception as e:
                print(f'ERROR processing {path}: {e}')

    if modified:
        print('Modified files:')
        for p in modified:
            print(p)
    else:
        print('No files modified')

if __name__ == '__main__':
    main()
