#!/usr/bin/env python3
from pathlib import Path
import re
import os

ROOT = Path(__file__).resolve().parents[1]
EMAIL = 'contact@jolkhabarstore.com'

def extract_help_block(text: str):
    m = re.search(r'(<div\s+class="help">[\s\S]*?<\/div>)', text, flags=re.IGNORECASE)
    return m.group(1) if m else None

def extract_anchor(text: str, pattern: str):
    m = re.search(pattern, text, flags=re.IGNORECASE)
    return m.group(0) if m else ''

def strip_tags(s: str):
    return re.sub(r'<[^>]+>', '', s).strip()

def build_help_block(gmap_span, tel_anchor, wa_anchor, mail_anchor, rights_line):
    # Extract img and text for tel
    def img_and_text(anchor_html):
        img = ''
        text = ''
        if not anchor_html:
            return img, text
        mimg = re.search(r'(<img[^>]+>)', anchor_html, flags=re.IGNORECASE)
        if mimg:
            img = mimg.group(1)
        text = strip_tags(anchor_html.replace(img, ''))
        return img, text

    tel_img, tel_text = img_and_text(tel_anchor)
    wa_img, wa_text = img_and_text(wa_anchor)
    mail_img, mail_text = img_and_text(mail_anchor)

    # Build anchors with standard hrefs but keep phone/wa numbers if available
    tel_href = 'tel:+918100627460'
    wa_href = 'https://wa.me/918100627460'
    mail_href = f'mailto:{EMAIL}'

    tel_line = f'        <a href="{tel_href}">\n          {tel_img}\n          {tel_text or "+91 8100627460"}\n        </a><br>'
    wa_line = f'        <a href="{wa_href}" target="_blank" rel="noopener noreferrer">\n          {wa_img}\n          {wa_text or "+91 8100627460"}\n        </a><br>'
    mail_line = f'        <a href="{mail_href}">\n          {mail_img}\n          <span class="footer-email">{EMAIL}</span>\n        </a><br>'

    parts = [
        '      <div class="help">',
        '        <strong>Help & Support</strong>',
        f'        {gmap_span}<br>' if gmap_span else '',
        tel_line,
        wa_line,
        mail_line,
        f'        {rights_line}',
        '      </div>'
    ]
    return '\n'.join([p for p in parts if p])

def process_file(html_path: Path):
    bak_path = html_path.with_suffix(html_path.suffix + '.bak')
    if not bak_path.exists():
        return False
    bak_text = bak_path.read_text(encoding='utf-8')
    html_text = html_path.read_text(encoding='utf-8')

    bak_help = extract_help_block(bak_text)
    if not bak_help:
        return False

    # Extract parts from bak
    gmap_span = extract_anchor(bak_help, r'<span>[\s\S]*?<\/span>')
    tel_anchor = extract_anchor(bak_help, r'<a[^>]*href\s*=\s*"tel:[^\"]*"[^>]*>[\s\S]*?<\/a>')
    wa_anchor = extract_anchor(bak_help, r'<a[^>]*href\s*=\s*"https?:\/\/wa\.me\/[^\"]*"[^>]*>[\s\S]*?<\/a>')
    mail_anchor = extract_anchor(bak_help, r'<a[^>]*href\s*=\s*"mailto:[^\"]*"[^>]*>[\s\S]*?<\/a>')

    # rights line: try to find &copy;... line in bak_help
    mrights = re.search(r'&copy;[\s\S]*?All\s+Rights\s+Reserved\.?', bak_help, flags=re.IGNORECASE)
    if mrights:
        rights_line = re.sub(r'All\s+Rights\s+Reserved\.?', 'All rights reserved.', mrights.group(0), flags=re.IGNORECASE)
    else:
        rights_line = '&copy; 2025 Siblings Exims Pvt. Ltd. <span class="rights">All rights reserved.</span>'

    new_help = build_help_block(gmap_span, tel_anchor, wa_anchor, mail_anchor, rights_line)

    # Replace current help block in html_text
    new_html = re.sub(r'<div\s+class="help">[\s\S]*?<\/div>\s*</div>\s*</footer>', new_help + '\n    </div>\n  </footer>', html_text, flags=re.IGNORECASE)

    if new_html != html_text:
        bak2 = html_path.with_suffix(html_path.suffix + '.bak2')
        if not bak2.exists():
            bak2.write_text(html_text, encoding='utf-8')
        html_path.write_text(new_html, encoding='utf-8')
        return True
    return False

def main():
    modified = []
    for root, dirs, files in os.walk(ROOT):
        dirs[:] = [d for d in dirs if d not in ('.git','node_modules','__pycache__')]
        for f in files:
            if not f.lower().endswith('.html'):
                continue
            path = Path(root)/f
            try:
                if process_file(path):
                    modified.append(str(path.relative_to(ROOT)))
            except Exception as e:
                print('ERR', path, e)

    if modified:
        print('Restored footers in:')
        for m in modified:
            print(m)
    else:
        print('No changes')

if __name__ == '__main__':
    main()
