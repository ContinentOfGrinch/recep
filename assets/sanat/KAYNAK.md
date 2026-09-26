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

İşleme: yüksek çözünürlüklü asıldan 16:9 kırpma → 720×405 → kontrast → Atkinson dither → 1-bit PNG (7–29 KB).
Değiştirmek için dosyayı aynı adla bu klasöre koyun; renk tuval zemini ve `mix-blend-mode` ile verilir (`$recep-tuval-*`).
