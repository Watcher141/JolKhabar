#!/usr/bin/env python3
from pathlib import Path
import re
import os

ROOT = Path(__file__).resolve().parents[1]
EMAIL = 'contact@jolkhabarstore.com'

def process(path: Path):
    text = path.read_text(encoding='utf-8')
    orig = text

    # Fix mailto hrefs that accidentally include HTML tags
    text = re.sub(r'href=("|\')mailto:[^"\']*("|\')', lambda m: f'href="mailto:{EMAIL}"', text, flags=re.IGNORECASE)

    # Also fix cases where href contains a tag (e.g., href="mailto:<span...)
    text = re.sub(r'href=\"mailto:\s*<[^\>]+>\s*([^\"]+)\"', lambda m: f'href="mailto:{EMAIL}"', text)

    # Collapse nested footer-email spans
    text = re.sub(r'<span[^>]*class=("|\')footer-email("|\')[^>]*>\s*<span[^>]*class=("|\')footer-email("|\')[^>]*>([^<]+)</span>\s*</span>',
                  lambda m: f'<span class="footer-email">{m.group(5)}</span>', text, flags=re.IGNORECASE)

    # Collapse nested rights spans
    text = re.sub(r'<span[^>]*class=("|\')rights("|\')[^>]*>\s*<span[^>]*class=("|\')rights("|\')[^>]*>([^<]+)</span>\s*</span>',
                  lambda m: f'<span class="rights">{m.group(5)}</span>', text, flags=re.IGNORECASE)

    # Remove footer-email inside href attributes if any remains like href="mailto:<span ... >..."
    text = re.sub(r'href=\"mailto:\s*<[^\>]+>\s*([^\"]+)\"', lambda m: f'href="mailto:{EMAIL}"', text)

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
        dirs[:] = [d for d in dirs if d not in ('.git','node_modules','__pycache__')]
        for f in files:
            if not f.lower().endswith('.html'):
                continue
            if f.lower().endswith('.html.bak'):
                continue
            path = Path(root)/f
            try:
                if process(path):
                    modified.append(str(path.relative_to(ROOT)))
            except Exception as e:
                print('Error', path, e)

    if modified:
        print('Modified files:')
        for m in modified:
            print(m)
    else:
        print('No changes')

if __name__ == '__main__':
    main()
