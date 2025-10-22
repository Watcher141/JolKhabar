from pathlib import Path
ROOT = Path(r"c:\Users\aviru\OneDrive\Documents\GitHub\JolKhabar\Products\product-details")
mods = []
for p in sorted(ROOT.glob('*.html')):
    txt = p.read_text(encoding='utf-8')
    new = txt.replace('href="../Styles/whatsapp-float.css"', 'href="../../Styles/whatsapp-float.css"')
    new = new.replace('src="./js/whatsapp-float.js"', 'src="../../js/whatsapp-float.js"')
    if new != txt:
        bak = p.with_suffix(p.suffix + '.bak')
        bak.write_text(txt, encoding='utf-8')
        p.write_text(new, encoding='utf-8')
        mods.append(str(p.relative_to(ROOT.parent.parent)))

print('Modified files:')
for m in mods:
    print(m)
print('Done')
