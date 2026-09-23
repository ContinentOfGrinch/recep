# recep

RECEP araştırma grubunun web sitesi — [Quarto](https://quarto.org) ile üretilir, GitHub Actions ile GitHub Pages'e yayımlanır.

## hızlı başlangıç

```bash
quarto preview        # canlı önizleme
quarto render         # tam derleme -> _site/
```

Gereksinimler: Quarto **1.10.18**, R ≥ 4.3 (yalnızca R kodu içeren sayfalar için; `plm`).

## içerik ekleme

| ne | nereye | şablon |
|---|---|---|
| blog yazısı | `blog/posts/YYYY-AA-GG-kisa-ad/index.qmd` | `_sablonlar/blog-yazisi.qmd` |
| proje | `projeler/kisa-ad.qmd` | `_sablonlar/proje.qmd` |
| rehber | `dokumantasyon/kisa-ad.qmd` | `_sablonlar/rehber.qmd` |
| ekip üyesi | `data/ekip.yml` | dosyadaki örnek blok |
| yayın | `data/yayinlar.yml` | dosyadaki örnek blok |

Yeni sayfalar menülere ve listelere otomatik eklenir. Başlıklar küçük harfle yazılır.

**R kodu içeren sayfa** eklediyseniz yerelde `quarto render <dosya>` çalıştırıp oluşan `_freeze/` klasörünü de commit edin. CI R kurmaz.

## yapı

```
_quarto.yml            site yapılandırması
theme.scss             tasarım sistemi (açık tema + tüm kurallar)
theme-dark.scss        koyu tema paleti
assets/fonts.css       kendi sunucumuzdaki fontlar (Inter, JetBrains Mono, Roboto Condensed)
data/                  ekip ve yayın verileri (YAML)
_templates/            ekip/yayın liste şablonları (EJS)
_sablonlar/            yeni içerik için kopyalanacak şablonlar
_freeze/               dondurulmuş R çıktıları (commit edilir)
.github/workflows/     derleme + link kontrolü + Pages dağıtımı
```

## yayın

`main` dalına her push'ta site derlenir, iç linkler kontrol edilir ve GitHub Pages'e yüklenir. Pull request'lerde yalnızca derleme ve link kontrolü çalışır.

İlk kurulum: **Settings → Pages → Source: GitHub Actions**.

## devir (organizasyona taşıma)

1. **Settings → General → Transfer ownership** ile repoyu hedef hesaba devredin.
2. `_quarto.yml` içindeki `site-url`, `repo-url` ve GitHub linklerini yeni adrese göre güncelleyin.
3. Yeni repoda **Settings → Pages → Source: GitHub Actions** ayarını doğrulayın.

## lisans

İçerik [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.tr), kod MIT. Fontlar SIL OFL 1.1 (`assets/fonts/`).
