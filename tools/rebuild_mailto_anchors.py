#!/usr/bin/env python3
from pathlib import Path
import re
import os

ROOT = Path(__file__).resolve().parents[1]
EMAIL = 'contact@jolkhabarstore.com'

def rebuild_footer_anchor(block: str) -> str:
    """Given a footer 'help' block string, find any anchor that should be mailto and rebuild it."""
    # Pattern to find an anchor tag that contains mailto or an email text
    # We'll search for <a ...> ... </a> occurrences inside the block
    def repl_anchor(match):
        a_tag = match.group(0)
        # Find any <img ...> inside
        img = ''
        m_img = re.search(r'<img[^>]+>', a_tag, flags=re.IGNORECASE)
        if m_img:
            img = m_img.group(0)
        # Build correct anchor
        return f'<a href="mailto:{EMAIL}">\n          {img}\n          <span class="footer-email">{EMAIL}</span>\n        </a>'

    new = re.sub(r'<a[^>]*>.*?<\/a>', repl_anchor, block, flags=re.IGNORECASE|re.DOTALL)
    return new

def process(path: Path):
    text = path.read_text(encoding='utf-8')
    orig = text

    # We look for the footer 'help' DIV and rebuild any anchors inside it
    def repl_help(m):
        block = m.group(0)
        new_block = rebuild_footer_anchor(block)
        return new_block

    text = re.sub(r'<div class="help">[\s\S]*?<\/div>\s*<\/div>\s*<\/footer>', repl_help, text, flags=re.IGNORECASE)

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
                print('ERR', path, e)

    if modified:
        print('Rebuilt anchors in:')
        for m in modified:
            print(m)
    else:
        print('No changes')

if __name__ == '__main__':
    main()
