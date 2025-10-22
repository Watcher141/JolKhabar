from pathlib import Path
ROOT = Path(r"c:\Users\aviru\OneDrive\Documents\GitHub\JolKhabar\Products\product-details")
results = []
for p in sorted(ROOT.glob('*.html')):
    txt = p.read_text(encoding='utf-8')
    has_anchor = 'class="whatsapp-float"' in txt
    has_script = 'js/whatsapp-float.js' in txt
    results.append((p.name, has_anchor, has_script))

print('file,has_anchor,has_script')
for r in results:
    print(','.join([r[0], str(r[1]), str(r[2])]))
