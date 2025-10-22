import re
from pathlib import Path

ROOT = Path(r"c:\Users\aviru\OneDrive\Documents\GitHub\JolKhabar")

WHATSAPP_SNIPPET = '''<a href="https://wa.me/918100627460" target="_blank" rel="noopener noreferrer" class="whatsapp-float" aria-label="Contact us on WhatsApp">
  <svg viewBox="0 0 24 24"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.21 3.08.149.199 1.671 2.554 4.053 3.582 2.381 1.028 2.381.686 2.81.64.43-.048 1.398-.569 1.595-1.119.198-.548.198-1.017.138-1.118-.06-.099-.273-.149-.57-.298z"/></svg>
</a>'''

STAR_REPLACEMENT = '★★★★☆'  # simple visible stars for 4-5 rating

modified_files = []

for path in ROOT.rglob('*.html'):
    # skip backups
    if path.suffix == '.bak':
        continue
    text = path.read_text(encoding='utf-8')
    orig = text
    changed = False

    # Ensure whatsapp float exists
    if 'class="whatsapp-float"' not in text:
        # Insert before closing </body> if present, otherwise append
        if '</body>' in text:
            text = text.replace('</body>', WHATSAPP_SNIPPET + '\n</body>')
        else:
            text = text + '\n' + WHATSAPP_SNIPPET
        changed = True

    # Replace rating placeholders ????? with stars
    new_text, n = re.subn(r'\?{4,}\?', STAR_REPLACEMENT, text)
    if n > 0:
        text = new_text
        changed = True

    if changed and text != orig:
        bak = path.with_suffix(path.suffix + '.bak')
        bak.write_text(orig, encoding='utf-8')
        path.write_text(text, encoding='utf-8')
        modified_files.append(str(path.relative_to(ROOT)))

# Print results
print('Modified files:')
for f in modified_files:
    print(f)
print('Done')
