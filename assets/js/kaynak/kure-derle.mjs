// kure.src.js + kara.json → assets/js/kure.js (veri gömülü, tamsayı ×10)
import fs from "node:fs";
const [srcJs, karaJson, out] = process.argv.slice(2);
const kara = JSON.parse(fs.readFileSync(karaJson, "utf8")).map(h => h.map(v => Math.round(v * 10)));
const js = fs.readFileSync(srcJs, "utf8").replace("/*KARA*/[]/*KARA*/", JSON.stringify(kara));
fs.writeFileSync(out, js);
console.log(out, fs.statSync(out).size, "bayt");
