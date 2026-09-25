# RECEP web sitesi — proje hafızası

> Her oturumun başında bu dosya okunur. Her önemli karar ve tamamlanan aşamadan sonra güncellenir.
> Son güncelleme: 2026-09-25 (tipografi v3, yayın kapat/aç)

## ✅ YAYIN DURUMU: AÇIK (2026-09-25 yeniden açıldı)

- 2026-09-25: kullanıcı isteğiyle kapatıldı (Pages silindi + publish iş akışı devre dışı), aynı gün tipografi v3 sonrası yeniden açıldı.
- **Kapatma:** `PUT .../actions/workflows/365129935/disable` + `DELETE .../pages` (CDN önbelleği ~10 dk içinde düşer).
- **Açma:** `PUT .../actions/workflows/365129935/enable` → `POST .../pages` `{"build_type":"workflow"}` → `POST .../actions/workflows/365129935/dispatches` `{"ref":"main"}` → Actions yeşil + canlı 200 kontrolü.
- GitHub dil çubuğu yalnızca SCSS/JS/EJS/CSS gösterir: `.qmd` (Quarto) ve `.yml` dosyaları Linguist tarafından dil olarak sayılmaz; `kure.js` (gömülü veri) üretilmiş dosya olarak dışlanır. Site yine de Quarto sitesidir; kullanıcıya açıklandı.

## ⚠ KESİN KURAL (kullanıcı, 2026-09-23)

**Kullanıcı bilgi verip onaylamadan kategorilerin (proje, ekip, çıktılar, veri ve kod, araçlar, haberler, iletişim) içine içerik YAZILMAZ.** Belgelerden özet, örnek veri, araç içeriği dahil. Sayfalar yalnızca iskelet: başlık + kullanıcının verdiği alt başlıklar + `.recep-bekliyor` kutusu ("içerik hazırlanıyor."). Önceden hazırlanmış içerikler `_taslaklar/` klasöründe (derlenmez, `_taslaklar/BENİOKU.md`); kullanıcı onaylarsa oradan geri taşınır. Tasarım/altyapı işleri serbest.

## 1. proje künyesi

- **Ne:** RECEP — *Çevre, Temiz Enerji ve Ekonomi Politikaları Araştırma Grubu* web sitesi.
- **Proje:** TÜBİTAK 1001, no **325K372** (dosya adından; doğrulanmalı). "AB SKDM'nin Türkiye Ekonomisine Etkileri: Sektörel Maliyet Yükü, Fiyat Etkileri ve Sosyo-Ekonomik Yansımaların Hibrit Girdi-Çıktı Modeli ile Analizi". Yürütücü Doç. Dr. Tunç Durmaz, YTÜ; ortak TÜİK; 24 ay; 4 iş paketi.
- **Yöntem (DİKKAT):** hibrit **Girdi-Çıktı (Leontief)** modeli + AB ithalat talep esneklikleri **2SLS** + mikro veri uydu hesapları. **Sistem GMM DEĞİL** (ilk oturumdaki varsayım yanlıştı, düzeltildi).
- **Kaynak belgeler (yerel, siteye konmaz):** `../1001_basvuru_formu_325K372R (1).pdf` (içerik kaynağı; bütçe/kişisel bilgi alınmadı), `../RECEP_Altyapi_ve_Web_Sitesi_Teklifi.docx`, `../skdm_toplantı.docx`, marka paketi `../Marka/logo_örnekleri/brand/` (svg, png, icons, src/globe.json).
- **Bütçe:** 0 TL. Açık kaynak + GitHub Pages + Actions.
- **GitHub:** https://github.com/ContinentOfGrinch/recep (public, `main`) → canlı: https://continentofgrinch.github.io/recep/ . Pages kaynağı = GitHub Actions. İleride Tunç Durmaz / lab organizasyonuna devredilecek (README'de adımlar).
- **Araçlar:** Quarto 1.10.18 (yerel = CI), R 4.5.1, Node 24. `gh` CLI yok → GitHub API için `git credential fill` token'ı + curl (Türkçe JSON → `--data-binary @dosya.json`).

## 2a. tipografi v3 — 3 katmanlı sistem (2026-09-25, "post-internet editorial / digital brutalism")

| katman | font | kullanım | kurallar |
|---|---|---|---|
| 1 · brütalist çapa | **Inter 900** (Helvetica Neue Black yedeği) | h1, h2, hero manşeti, logo `[recep]` | `letter-spacing: -0.05em` (`$brutal-tracking`), line-height ~1.0, küçük harf |
| 2 · editoryal hümanizm | **Lora** 400–700 + italik | `<body>`, paragraf, liste, alıntı, makale | line-height 1.7, normal harf aralığı, 17px taban |
| 3 · terminal / ui | **JetBrains Mono** (Space Mono yedek) | menü, buton, form, etiket, tarih/yazar, koordinat, breadcrumb, sidebar, TOC, footer, h3–h6, kod | 12–14px, küçük/büyük harf |

- CSS değişkenleri `--font-brutal / --font-editorial / --font-terminal`; yardımcı sınıflar `.font-brutal / .font-editorial / .font-terminal` (Markdown: `[metin]{.font-terminal}`). Tailwind YOK (Quarto + SCSS) — kullanıcıya eşdeğer olarak bildirildi.
- Fontlar kendi sunucumuzda (fontsource = Google Fonts dosyaları, latin + latin-ext). **Roboto Condensed kaldırıldı.**
- Açık tema paleti güncellendi: zemin kırık beyaz **#F4F2EC**, metin zifiri **#0A0A0A**, soluk #3D3D3A, çizgi #C9C4B8, yüzey #EAE7DE. Gece paleti değişmedi.
- `p, li {Lora}` gibi geniş seçiciler KULLANMA: menü/footer listelerini de Lora'ya çeker; `body` kalıtımı yeterli.

## 2. tasarım manifestosu v2 (güncel, değişmez)

- **Dil:** "bilimsel brutalizm" + siberpunk/terminal. Tüm köşeler keskin (`border-radius: 0`, `$enable-rounded: false` + global `*{border-radius:0!important}`).
- **Palet — gece (VARSAYILAN):** zemin #05080D, metin #E6EDF3, soluk #8B98A5, çizgi #1C2633, yüzey #0B111A, **neon yeşil #39FF14**, **elektrik mavi #00A3FF**.
- **Palet — açık:** bkz. 2a (kırık beyaz #F4F2EC, zifiri #0A0A0A); yeşil **#12A12F**, mavi **#0077CC**.
- **Navbar (v3, kullanıcı düzeltmesi):** **tek satır, bölünmüş:** SOL `proje · ekip · çıktılar` | MERKEZ [küre + [recep]] | SAĞ `veri ve kod · araçlar · haberler · iletişim`. Alt alta YOK, logo solda YOK. Her iki temada #05080D, sabit (`pinned` + `z-index: 9999`). ≥1200px: `.navbar-collapse{display:contents}` + grid `1fr auto 1fr`; Quarto `left:`→`.me-auto`, `right:`→`.ms-auto`. GitHub+tema düğmesi sol kenarda, arama sağ kenarda (mutlak). <1200px (`collapse-below: xl`): [menü düğmesi | marka | tema+arama], menü aşağı açılır.
- **Logo/küre:** `assets/js/kure.js` — **gerçekten dönen wireframe dünya** (canvas, kütüphanesiz ortografik izdüşüm, Natural Earth 110m kıyı çizgileri neon yeşil, 20° ağ elektrik mavi), **Türkiye'de (35.2E, 39.0N) yanıp sönen neon kırmızı nokta + radar halkası** (#FF1F4B), küreyle birlikte döner, arka yüzde gizlenir. Eğim 24° (kuzeyden). Navbar'da `.navbar-logo` img → 46px canvas (hız 0.018°/ms); hero'da `.recep-kure` (hız 0.006, dış kesikli halka ters döner, renkler CSS değişkenlerinden `--recep-yesil/mavi/kirmizi/zemin`). JS yoksa yedek: `amblem-nav.svg` / `amblem-koyu.svg`. `prefers-reduced-motion` → tek kare. IntersectionObserver ile görünmezken durur.
- **Küre derleme:** kaynak `assets/js/kure.src.js`; veri `assets/js/kaynak/kara-110m.json`; `node assets/js/kaynak/kure-derle.mjs assets/js/kure.src.js assets/js/kaynak/kara-110m.json assets/js/kure.js`. Yükleyici `_quarto.yml` `include-after-body` içinde, `<meta name="quarto:offset">` ile her derinlikte doğru yol.
- [recep] metni **Inter 900** (marka kelime işaretine en yakın), köşeli parantezler CSS kenarlıklarıyla kalın kare çizgi.
- **Çerçeveler:** kart ızgarası, butonlar, şeritler `$recep-frame` (gece #00A3FF / açık #0077CC); birincil buton ve hero küre çerçevesi neon yeşil; hero'da terminal ızgarası + mavi köşe imleri.
- **Gece varsayılanı garantisi:** `include-in-header` betiği, eski sürümden kalan `quarto-color-scheme` tercihini bir kez siler (`recep-tema=v2` bayrağı) ve gerekirse sayfayı yeniler.
- **Tipografi:** bkz. 2a (3 katman: Inter 900 · Lora · JetBrains Mono). Başlıklar küçük harf. h2 önüne `# ` (yeşil), h3 önüne `## ` (mavi); `.no-prefix` ile kapatılır.
- **Etkileşim dili:** hover'da `translate(-2px,-2px)` + `4px 4px 0` neon gölge (brutalist), kartlarda alttan dolan neon çizgi.

## 3. site mimarisi (kalıcı adresler)

**Şu an tüm kategoriler İSKELET (içerik bekliyor).**

| menü | adres | alt kategoriler (sayfa) | altyapı |
|---|---|---|---|
| proje | /proje/ | amac-kapsam, yontem, is-paketleri, tubitak | sidebar |
| ekip | /ekip/ | yürütücü, araştırmacılar, danışmanlar, bursiyerler (tek sayfa, gruplar) | `data/ekip.yml` (boş, `rol: yok` yer tutucu) + `_templates/ekip.ejs` |
| çıktılar | /ciktilar/ | politika-notlari, tebligler-makaleler, sunumlar | `data/ciktilar.yml` (`bolum` ile süzülür) + `_templates/ciktilar.ejs` |
| veri ve kod | /veri-kod/ | uyumlastirma-anahtarlari (NACE–ISCO–GTİP), veri-setleri, analiz-kodlari | sidebar |
| araçlar | /araclar/ | skdm-hesaplayici, karbon-fiyati | sidebar; OJS altyapısı `_taslaklar/araclar/` içinde hazır |
| haberler | /haberler/ | duyurular, etkinlikler, çalıştay haberleri (kartlar) | ilk haberde listing + RSS açılacak (`_taslaklar/haberler/index.qmd` şablon); `haberler/posts/_metadata.yml` hazır |
| iletişim | /iletisim/ | e-posta, adres, sosyal medya bağlantıları (kartlar) | — |

- Sidebar: proje, ciktilar, veri-kod, araclar → `- auto: <klasör>`, sıra `order` alanıyla; bölüm index'i `order: 0`.
- İskeletler `scratchpad/iskelet.mjs` ile üretildi (yeniden gerekmez).
- RSS bağlantıları navbar/footer'dan kaldırıldı (haber yokken kırık olurdu); ilk haberle geri eklenecek.

## 4. teknik kararlar ve tuzaklar

| konu | karar / tuzak |
|---|---|
| Tema sırası | `format.html.theme` içinde **dark önce** → varsayılan gece; `respect-user-color-scheme: false`. |
| OJS tema izleme | `Generators.observe` + MutationObserver(body.class). **Yalnızca değer değişince notify et** — aksi halde Quarto'nun body sınıfı değişiklikleri sonsuz yeniden çizim döngüsü yaratır. |
| OJS + file:// | OJS sayfaları `file://` ile headless tarayıcıda **donar** (modül yükleme). Test için yerel HTTP sunucusu: `node scratchpad/sunucu.mjs _site` (port 4321, `/recep/` önekini soyar). Canlıda sorun yok. |
| Grafikler | Observable Plot, tek seri (kategorik palet gerekmez), `tip` ile hover, `Inputs.table` ile tablo görünümü; paletler JS'te iki tema için sabit. dataviz validator: açık palet PASS; gece neon "lightness band" FAIL yalnızca kategorik çiftte geçerli, tek seride sorun değil. |
| SKDM geçiş takvimi | pay = ücretsiz tahsisin kaldırılma oranı: 2026 %2,5 · 2027 %5 · 2028 %10 · 2029 %22,5 · 2030 %48,5 · 2031 %61 · 2032 %73,5 · 2033 %86 · 2034 %100. |
| Temsili veriler | Hesaplayıcı emisyon yoğunlukları ve ETS yıllık ortalamaları **yaklaşık/temsili**; sayfalarda uyarı var; resmi kaynakla değiştirilecek. |
| Marka SVG'leri | C2PA meta verisi soyularak (`scratchpad/amblem.mjs`) `assets/marka/` altına alındı: amblem-nav/koyu/acik (animasyonlu), recep-yatay-koyu/acik (svg+png), apple-touch-icon; `assets/favicon.svg`, `assets/og.png` (1200×630, marka paketinden). |
| Footer linki | Proje kökü mutlak yol: `/proje/tubitak.qmd` (göreli yazılırsa alt sayfalarda kırılır). |
| EJS | Şablonlar ```` ```{=html} ```` içinde; listing verisi `_` klasöründe olamaz (`data/`). Listing `include: {bolum: ...}` ile süzme çalışıyor. |
| Fontlar | self-host woff2 (Inter değişken 100–900 → logo için 900 kullanılıyor). |
| Bash | `python` çağırma (Store alias, takılır). Heredoc'ta Türkçe kesme işaretli uzun metinler bazen kabuğu bozuyor → Write aracı kullan. |

## 5. doğrulama yöntemi

- `rm -rf _site && quarto render` → uyarısız olmalı.
- Ekran görüntüsü: headless Edge, her çağrıda **ayrı `--user-data-dir`**, `--virtual-time-budget=6000`. OJS sayfaları için HTTP sunucusu şart. Açık tema: sayfada `localStorage.setItem("quarto-color-scheme","alternate")` sonrası yönlendirme.
- Headless minimum genişlik ~481px.

## 6. tamamlanan aşamalar

- [x] Aşama 1–2 (2026-09-23): ilk iskelet, altyapı, CI (render + lychee + Pages), self-host fontlar, repo + ilk yayın.
- [x] Aşama 3 (2026-09-23): **yeniden tasarım** — manifesto v2 paleti, iki satırlı ortalanmış navbar + animasyonlu marka amblemi, 7 bölümlü yeni bilgi mimarisi, başvuru formundan proje içeriği, ekip verisi, SKDM hesaplayıcısı ve karbon fiyatı paneli (OJS), GTİP→NACE taslak anahtar, R Leontief demosu, iş-zaman çizelgesi. Gece/mobil/araç sayfaları ekran görüntüsüyle doğrulandı.

- [x] Aşama 4 (2026-09-23, kullanıcı düzeltmesi): bölünmüş tek satır navbar + merkez logo; canvas tabanlı gerçekten dönen wireframe küre + Türkiye'de yanıp sönen kırmızı nokta (navbar + hero); neon çerçeveler; gece varsayılanı sıfırlama betiği; tüm kategoriler iskelete çevrildi, içerikler `_taslaklar/`'a taşındı. Dönüş CDP ile gerçek zamanlı doğrulandı (3 sn arayla kare özetleri farklı).

## 7. açık işler / TODO

- [x] Aşama 3 commit `c5d83f9` + push; Actions başarılı; canlıda 13 adres 200, araçlar çalışıyor. Açık tema, ekip ve mobil ekran görüntüleriyle doğrulandı (açık temada amblem-acik'in gri arka plan kutusu kaldırıldı).
- [ ] Kullanıcıdan doğrulanacaklar: proje no 325K372, başlangıç tarihi, ekip listesinin yayımlanma onayı, kurumlar (Avşar, Arı, Demir), iletişim e-postası ve adres.
- [ ] Temsili verileri resmi kaynaklarla değiştir: ETS yıllık ortalamaları (ICAP/EEX), SKDM varsayılan emisyon değerleri.
- [ ] GTİP→NACE anahtarını Ek I alt pozisyon istisnalarıyla doğrula.
- [ ] İngilizce sürüm (tablo: About, Team, Outputs, Data & Code, Tools, News, Contact) — Quarto profilleri veya `/en/` alt ağacı ile; henüz başlanmadı.
- [ ] `renv` ile R paketlerini kilitle (R içeriği büyüyünce).

- **Doğrulama notu:** headless tarayıcıda `--virtual-time-budget` requestAnimationFrame'i ilerletmez (4 sn'de 6 kare). Animasyon kontrolü için `scratchpad/cdp.mjs` (Edge `--remote-debugging-port=9333` + Node WebSocket, gerçek zamanlı ölçüm ve ekran görüntüsü). Headless Edge'i kapatırken genel `taskkill /IM msedge.exe` KULLANMA (kullanıcının tarayıcısını etkileyebilir); yalnızca `edge-cdp` profilli süreçleri hedefle.
- **Kabuk notu:** `node -e '...'` içinde tek tırnaklı JS dizeleri kabukta düşer → tırnak içeren düzenlemeleri Edit/Write ile yap.

## 8. sıradaki adım

**Kullanıcının kategori bilgilerini göndermesini bekle.** Gelen her bilgiyi yalnızca ilgili kategoriye işle; `_taslaklar/` içeriğini ancak kullanıcı onaylarsa kullan. Bekleme sürecinde yalnızca tasarım/altyapı işleri yapılabilir.
