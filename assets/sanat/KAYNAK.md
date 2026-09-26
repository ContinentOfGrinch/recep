# sanat eserleri — kaynak ve işleme

Tüm eserler **kamu malıdır** (public domain) ve Wikimedia Commons'tan alınmıştır.
Sitede `DynamicHero` filtresi (`_extensions/recep/hero/`) tarafından alt sayfaların başındaki
tam opak "art canvas" tuvalinde kullanılır (ana sayfada eser yok, dönen küre var).

| dosya | eser | sekmeler | Commons dosyası |
|---|---|---|---|
| athens.png | Raphael, *Atina Okulu*, 1509–1511 | ekip, 404 | "The School of Athens" by Raffaello Sanzio da Urbino.jpg |
| ambassadors.png | Hans Holbein (Genç), *Elçiler*, 1533 | haberler, iletişim | Hans Holbein the Younger - The Ambassadors - Google Art Project.jpg |
| vitruvian.png | Leonardo da Vinci, *Vitruvius Adamı*, y. 1490 | veri ve kod, araçlar | Da Vinci Vitruve Luc Viatour.jpg |
| adam.png | Michelangelo, *Adem'in Yaratılışı*, y. 1508–1512 | proje, çıktılar | Michelangelo - Creation of Adam (cropped).jpg |
| syndics.png | Rembrandt, *Kumaşçılar Loncası Yöneticileri (De Staalmeesters)*, 1662 | hakkımızda | Rembrandt - De Staalmeesters- het college van staalmeesters (waardijns) van het Amsterdamse lakenbereidersgilde - Google Art Project.jpg |

İşleme: yüksek çözünürlüklü asıldan 16:9 kırpma → 720×405 → kontrast → Atkinson dither → 1-bit PNG (7–29 KB).
Değiştirmek için dosyayı aynı adla bu klasöre koyun; renk tuval zemini ve `mix-blend-mode` ile verilir (`$recep-tuval-*`).


## ambassadors.png — haberler + iletişim (ince taneli)

Holbein asli (Google Art Project, kamu malı), 16:9 kırpım (cy .36), **859×483** = sayfadaki tuval genişliği
(masaüstünde 1:1, retinada 2×; 1280 px altında yumuşak ölçekleme). Floyd–Steinberg (serpantin),
hafif keskinleştirme, yumuşak ton eğrisi (sert eşik yok), 4 ince tarama satırı kayması.
Yeniden üretim: scratchpad `sanat/elciler.html` + `elciler-surucu.mjs` + `e3.json`.

## pacioli.png — araçlar (tam tablo, 16:9 tuvale yerleştirilmiş)

Jacopo de' Barbari (atf.), *Luca Pacioli portresi*, 1495 — kamu malı. Commons: "Jacopo de' Barbari (attributed to)
Portrait of Luca Pacioli (1445 1517) with a student (Guidobaldo da Montefeltro) (2).jpg" (3000×2500).
Tablo 1,2:1 olduğu için **kırpılmadı**: 580×483 ince taneli Floyd–Steinberg, 859×483 siyah tuvale sağa yaslı
(sol 279 px saf siyah; başlık bu alana oturur). Glitch yok. `sabit = true` → alt sayfalarda da 16:9.
Yeniden üretim: scratchpad `sanat/elciler.html` + `tablo-surucu.mjs` + `pacioli.json`.
