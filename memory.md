# RECEP web sitesi — proje hafızası

> Her oturumun başında bu dosya okunur. Her önemli karar ve tamamlanan aşamadan sonra güncellenir.
> Son güncelleme: 2026-09-23 (oturum 1, aşama 3 — yeniden tasarım)

## 1. proje künyesi

- **Ne:** RECEP — *Çevre, Temiz Enerji ve Ekonomi Politikaları Araştırma Grubu* web sitesi.
- **Proje:** TÜBİTAK 1001, no **325K372** (dosya adından; doğrulanmalı). "AB SKDM'nin Türkiye Ekonomisine Etkileri: Sektörel Maliyet Yükü, Fiyat Etkileri ve Sosyo-Ekonomik Yansımaların Hibrit Girdi-Çıktı Modeli ile Analizi". Yürütücü Doç. Dr. Tunç Durmaz, YTÜ; ortak TÜİK; 24 ay; 4 iş paketi.
- **Yöntem (DİKKAT):** hibrit **Girdi-Çıktı (Leontief)** modeli + AB ithalat talep esneklikleri **2SLS** + mikro veri uydu hesapları. **Sistem GMM DEĞİL** (ilk oturumdaki varsayım yanlıştı, düzeltildi).
- **Kaynak belgeler (yerel, siteye konmaz):** `../1001_basvuru_formu_325K372R (1).pdf` (içerik kaynağı; bütçe/kişisel bilgi alınmadı), `../RECEP_Altyapi_ve_Web_Sitesi_Teklifi.docx`, `../skdm_toplantı.docx`, marka paketi `../Marka/logo_örnekleri/brand/` (svg, png, icons, src/globe.json).
- **Bütçe:** 0 TL. Açık kaynak + GitHub Pages + Actions.
- **GitHub:** https://github.com/ContinentOfGrinch/recep (public, `main`) → canlı: https://continentofgrinch.github.io/recep/ . Pages kaynağı = GitHub Actions. İleride Tunç Durmaz / lab organizasyonuna devredilecek (README'de adımlar).
- **Araçlar:** Quarto 1.10.18 (yerel = CI), R 4.5.1, Node 24. `gh` CLI yok → GitHub API için `git credential fill` token'ı + curl (Türkçe JSON → `--data-binary @dosya.json`).

## 2. tasarım manifestosu v2 (güncel, değişmez)

- **Dil:** "bilimsel brutalizm" + siberpunk/terminal. Tüm köşeler keskin (`border-radius: 0`, `$enable-rounded: false` + global `*{border-radius:0!important}`).
- **Palet — gece (VARSAYILAN):** zemin #05080D, metin #E6EDF3, soluk #8B98A5, çizgi #1C2633, yüzey #0B111A, **neon yeşil #39FF14**, **elektrik mavi #00A3FF**.
- **Palet — açık:** zemin #FFFFFF, metin #0B1220, soluk #4B5563, çizgi #D0D7DE, yüzey #F3F5F7, yeşil **#12A12F**, mavi **#0077CC**.
- **Navbar:** her iki temada #05080D, sabit (Quarto `pinned` + `z-index: 9999`), **iki satır**: üstte ortada amblem + [recep], sağda araçlar/arama; altta ortalanmış 7 menü (JetBrains Mono, küçük harf, aktif öğe `> ` + neon alt çizgi).
- **Logo:** marka paketindeki küre amblemi (AB–TR noktalı yay = SKDM hattı). Navbar'da `assets/marka/amblem-nav.svg` (**dönen kesikli halka, akan AB–TR yayı, nabız atan noktalar**; CSS animasyonu SVG içinde, `prefers-reduced-motion` destekli). [recep] metni **Inter 900** (marka kelime işaretindeki ağır grotesk'e en yakın; Roboto Condensed yerine bilinçli seçim), köşeli parantezler CSS kenarlıklarıyla kalın kare çizgi.
- **Tipografi:** h1–h2 Roboto Condensed Bold, h3–h6 + menü + etiketler JetBrains Mono, gövde Inter. Hepsi küçük harf. h2 önüne `# ` (yeşil), h3 önüne `## ` (mavi); `.no-prefix` ile kapatılır.
- **Etkileşim dili:** hover'da `translate(-2px,-2px)` + `4px 4px 0` neon gölge (brutalist), kartlarda alttan dolan neon çizgi.

## 3. site mimarisi (kalıcı adresler)

| menü | adres | içerik | kaynak |
|---|---|---|---|
| proje | /proje/ | index (amaç-kapsam), yontem, is-paketleri (JS gantt), tubitak | başvuru formu |
| ekip | /ekip/ | yürütücü, araştırmacılar, danışmanlar, bursiyerler | `data/ekip.yml` + `_templates/ekip.ejs` |
| çıktılar | /ciktilar/ | index + politika-notlari, tebligler-makaleler, sunumlar | `data/ciktilar.yml` (`bolum` alanı ile süzülür) + `_templates/ciktilar.ejs` |
| veri ve kod | /veri-kod/ | uyumlastirma-anahtarlari (SKDM Ek I GTİP→NACE taslak CSV), veri-setleri, analiz-kodlari (R Leontief demo, freeze) | `veri-kod/veri/*.csv` |
| araçlar | /araclar/ | skdm-hesaplayici (OJS), karbon-fiyati (OJS + CSV) | `araclar/veri/ab-ets-yillik.csv` |
| haberler | /haberler/ | grid listing + RSS (`haberler/index.xml`) | `haberler/posts/YYYY-AA-GG-slug/` |
| iletişim | /iletisim/ | e-posta, adres, bağlantılar | yer tutucular |

- Sidebar: proje, ciktilar, veri-kod, araclar → `- auto: <klasör>`, sıra `order` alanıyla.
- Ekip adları başvuru formundaki kadrodan: Durmaz (yürütücü); Avşar, Güngör, Şahin, Çivit (TÜİK), Alpar (TÜİK) (araştırmacı); Arı, Demir (danışman); bursiyerler boş → "belirlendiğinde" mesajı.
- Çıktılar boş: `data/ciktilar.yml` içinde `bolum: yok` yer tutucu kayıt var (boş listing hatasını önler, şablon süzüyor).

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

## 7. açık işler / TODO

- [x] Aşama 3 commit `c5d83f9` + push; Actions başarılı; canlıda 13 adres 200, araçlar çalışıyor. Açık tema, ekip ve mobil ekran görüntüleriyle doğrulandı (açık temada amblem-acik'in gri arka plan kutusu kaldırıldı).
- [ ] Kullanıcıdan doğrulanacaklar: proje no 325K372, başlangıç tarihi, ekip listesinin yayımlanma onayı, kurumlar (Avşar, Arı, Demir), iletişim e-postası ve adres.
- [ ] Temsili verileri resmi kaynaklarla değiştir: ETS yıllık ortalamaları (ICAP/EEX), SKDM varsayılan emisyon değerleri.
- [ ] GTİP→NACE anahtarını Ek I alt pozisyon istisnalarıyla doğrula.
- [ ] İngilizce sürüm (tablo: About, Team, Outputs, Data & Code, Tools, News, Contact) — Quarto profilleri veya `/en/` alt ağacı ile; henüz başlanmadı.
- [ ] `renv` ile R paketlerini kilitle (R içeriği büyüyünce).

## 8. sıradaki adım

Kullanıcıdan doğrulama listesini (bölüm 7) al ve işle: proje no/başlangıç, ekip onayı ve kurumları, iletişim bilgileri. Ardından temsili verileri resmi kaynaklarla değiştir ve İngilizce sürüm kararını ver.
