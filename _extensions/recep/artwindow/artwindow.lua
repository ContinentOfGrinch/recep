--[[
  recep · "Art Terminal Window" (<ArtWindow />) — Quarto kısa kodu

  Kullanım:
    {{< artwindow gorsel="athens" meta="> RNDR_ATHENS_SCHOOL.exe // LAT:41.025 LON:28.889"
                  alt="Raphael, Atina Okulu" kunye="RAPHAEL · 1509–1511 · PUBLIC DOMAIN"
                  renk="mavi" oran="4/3" konum="50% 45%" >}}

  Parametreler:
    gorsel  : assets/sanat/<ad>.png kısaltması  ya da proje köküne göre yol ("/assets/...")
    meta    : üst çubuktaki terminal dizesi (büyük harf, Katman 3)
    alt     : erişilebilirlik metni
    kunye   : alt çubuktaki künye (isteğe bağlı)
    renk    : mavi (varsayılan, #00A3FF) | yesil (#39FF14)
    oran    : pencere en-boy oranı (varsayılan 4/3)
    konum   : object-position — kırpma odağı (varsayılan "50% 50%")
    ters    : "evet" → negatif (beyaz kâğıt üzerindeki çizimler için)
    ton     : "evet" → neon renkli duotone (varsayılan siyah-beyaz)
]]

local function yazi(kw, ad, varsayilan)
  local v = kw[ad]
  if v == nil then return varsayilan end
  v = pandoc.utils.stringify(v)
  if v == "" then return varsayilan end
  return v
end

local function kacis(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

return {
  ["artwindow"] = function(args, kwargs, meta)
    if not quarto.doc.is_format("html") then return pandoc.Null() end

    local gorsel = yazi(kwargs, "gorsel", "athens")
    if not gorsel:find("/") then gorsel = "/assets/sanat/" .. gorsel .. ".png" end
    local metaYazi = yazi(kwargs, "meta", "> RNDR.exe")
    local alt      = yazi(kwargs, "alt", "")
    local kunye    = yazi(kwargs, "kunye", "")
    local renk     = yazi(kwargs, "renk", "mavi")
    local oran     = yazi(kwargs, "oran", "4/3")
    local konum    = yazi(kwargs, "konum", "50% 50%")
    local ters     = yazi(kwargs, "ters", "hayir") == "evet"
    local ton      = yazi(kwargs, "ton", "hayir") == "evet"

    local siniflar = "recep-art recep-art--" .. renk
    if ters then siniflar = siniflar .. " recep-art--ters" end
    if ton then siniflar = siniflar .. " recep-art--ton" end

    -- <figure> yerine <div role="figure">: Quarto'nun figür/sütun işlemesi bileşeni bozmasın
    local ac = string.format(
      '<div class="%s" role="figure" aria-label="%s" style="--oran: %s; --konum: %s;">' ..
      '<div class="recep-art-meta"><span class="komut">%s</span><span class="durum" aria-hidden="true">REC</span></div>' ..
      '<div class="recep-art-pencere">',
      siniflar, kacis(alt), kacis(oran), kacis(konum), kacis(metaYazi))

    local koseler =
      '<span class="kose k-ust-sol" aria-hidden="true"></span><span class="kose k-ust-sag" aria-hidden="true"></span>' ..
      '<span class="kose k-alt-sol" aria-hidden="true"></span><span class="kose k-alt-sag" aria-hidden="true"></span>' ..
      '<span class="arti" aria-hidden="true"></span></div>'

    local kapa = (kunye ~= "" and ('<div class="recep-art-alt">' .. kacis(kunye) .. '</div>') or "") .. '</div>'

    -- Görsel, Quarto'nun yol çözümlemesi için pandoc Image olarak üretilir
    local img = pandoc.Image({}, gorsel, "", pandoc.Attr("", {}, { { "alt", alt }, { "loading", "lazy" }, { "decoding", "async" } }))

    return pandoc.Plain({
      pandoc.RawInline("html", ac),
      img,
      pandoc.RawInline("html", koseler .. kapa),
    })
  end
}
