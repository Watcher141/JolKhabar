from pathlib import Path
ROOT = Path(r"c:\Users\aviru\OneDrive\Documents\GitHub\JolKhabar")
SCRIPT_SNIPPET = '\n<script src="./js/whatsapp-float.js" defer></script>\n'
modified = []
for p in ROOT.rglob('*.html'):
    if p.name.endswith('.bak'):
        continue
    text = p.read_text(encoding='utf-8')
    if 'js/whatsapp-float.js' in text:
        continue
    if '</body>' in text:
        bak = p.with_suffix(p.suffix + '.bak')
        bak.write_text(text, encoding='utf-8')
        text = text.replace('</body>', SCRIPT_SNIPPET + '</body>')
        p.write_text(text, encoding='utf-8')
        modified.append(str(p.relative_to(ROOT)))
print('Modified files:')
for m in modified:
    print(m)
print('Done')
