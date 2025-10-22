from pathlib import Path
import re

ROOT = Path(r"c:\Users\aviru\OneDrive\Documents\GitHub\JolKhabar")
WHATSAPP_SNIPPET = '<a href="https://wa.me/918100627460" target="_blank" rel="noopener noreferrer" class="whatsapp-float" aria-label="Contact us on WhatsApp">...</a>'

missing_float = []
still_question = []

for path in ROOT.rglob('*.html'):
    if path.name.endswith('.bak'):
        continue
    text = path.read_text(encoding='utf-8')
    if 'class="whatsapp-float"' not in text:
        missing_float.append(str(path.relative_to(ROOT)))
    if '????' in text:
        still_question.append(str(path.relative_to(ROOT)))

print('Files missing whatsapp-float (%d):' % len(missing_float))
for f in missing_float:
    print(f)
print('\nFiles still containing "????" (%d):' % len(still_question))
for f in still_question:
    print(f)
