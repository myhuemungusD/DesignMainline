// Public-site edit for Caviot Studio: the bundled fonts are licensed for the owner's personal use only,
// so forge/ ships without them. Visitors use the system font or upload their own.
// Run by sync-caviot.sh; every edit must match exactly once so an app change fails loudly instead of
// silently shipping the fonts again.
import fs from 'node:fs';import path from 'node:path';
const dir=process.argv[2];if(!dir)throw Error('usage: public-fonts.mjs <forge dir>');
const fonts=path.join(dir,'fonts');
for(const f of fs.readdirSync(fonts))if(/\.(ttf|otf|woff2?)$/i.test(f))fs.rmSync(path.join(fonts,f));
fs.rmSync(path.join(fonts,'notices'),{recursive:true,force:true});
fs.writeFileSync(path.join(fonts,'catalog.js'),'globalThis.BUILTIN_FONTS=[];\n');
fs.writeFileSync(path.join(fonts,'catalog.json'),'[]\n');
const edit=(file,from,to)=>{const p=path.join(dir,file),s=fs.readFileSync(p,'utf8'),n=s.split(from).length-1;
  if(n!==1)throw Error(`${file}: expected 1 match, found ${n}: ${from.slice(0,60)}`);fs.writeFileSync(p,s.replace(from,to));};
edit('builtin-fonts.js','els.fontChoice.prepend(group);','if(BUILTIN_FONTS.length)els.fontChoice.prepend(group);');
edit('builtin-fonts.js',"els.fontName.textContent=BUILTIN_FONTS.length+' included fonts'+(customFontRecords.length?' + '+customFontRecords.length+' uploaded':'');",
  "els.fontName.textContent=customFontRecords.length?customFontRecords.length+' uploaded font'+(customFontRecords.length>1?'s':''):'Upload your own font (TTF, OTF, WOFF) or use the system font.';");
edit('index.html','Lettering font · 120 included</label>','Lettering font</label>');
edit('product.js','Your 120 supplied font files are included in the font picker and load when selected. Additional uploaded fonts are stored',
  'Use the system font or upload your own (TTF, OTF, WOFF). Uploaded fonts are stored');
console.log('public-fonts: removed bundled fonts');
