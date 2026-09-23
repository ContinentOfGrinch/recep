/* recep · dönen wireframe dünya küresi
 * Harici kütüphane yok: ortografik izdüşüm + arka yüz kırpma, <canvas> üzerinde.
 * Kara verisi: Natural Earth 110m (kamu malı), world-atlas üzerinden; 0.1° hassasiyet.
 * Yerleşim:
 *   - navbar: .navbar-logo <img> aynı boyutta bir <canvas> ile değiştirilir (neon palet, sabit)
 *   - sayfa:  <div class="recep-kure" data-hiz="…"> içine yerleşir (renkler CSS değişkenlerinden)
 * prefers-reduced-motion: tek kare çizilir, döndürülmez.
 */
(() => {
  "use strict";
  const KARA = /*KARA*/[]/*KARA*/;               // [[lon*10, lat*10, ...], ...]
  const TURKIYE = [35.2, 39.0];                   // lon, lat
  const DERECE = Math.PI / 180;
  const EGIM = 24;                                // bakış enlemi: kuzeyden, Türkiye merkeze yakın
  const azHareket = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  const halkalar = KARA.map(h => { const r = new Float32Array(h.length); for (let i = 0; i < h.length; i++) r[i] = h[i] / 10; return r; });

  // enlem-boylam ağı (20°): her çizgi [lon,lat,...]
  const ag = [];
  for (let lon = -180; lon < 180; lon += 20) { const c = []; for (let lat = -90; lat <= 90; lat += 4) c.push(lon, lat); ag.push(c); }
  for (let lat = -60; lat <= 60; lat += 20) { const c = []; for (let lon = -180; lon <= 180; lon += 4) c.push(lon, lat); ag.push(c); }

  const NEON = { kara: "#39FF14", ag: "#00A3FF", nokta: "#FF1F4B", zemin: "#05080D" };

  function cssRenkler() {
    const s = getComputedStyle(document.documentElement);
    const al = (ad, yedek) => (s.getPropertyValue(ad).trim() || yedek);
    return { kara: al("--recep-yesil", NEON.kara), ag: al("--recep-mavi", NEON.ag), nokta: al("--recep-kirmizi", NEON.nokta), zemin: al("--recep-zemin", NEON.zemin) };
  }

  function kur(canvas, secenek) {
    const ctx = canvas.getContext("2d");
    const kucuk = secenek.boyut < 80;
    let renk = secenek.renk ? secenek.renk() : NEON;
    let lambda0 = TURKIYE[0];                      // Türkiye önde başlar
    let son = performance.now(), gorunur = true, dpr = 1, boyut = 0;

    function olcekle() {
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      boyut = secenek.boyut || canvas.clientWidth || 300;
      canvas.width = Math.round(boyut * dpr); canvas.height = Math.round(boyut * dpr);
      canvas.style.width = boyut + "px"; canvas.style.height = boyut + "px";
    }

    function ciz(zaman) {
      const R = boyut / 2 - (kucuk ? 3 : boyut * 0.09);
      const cx = boyut / 2, cy = boyut / 2;
      const l0 = lambda0 * DERECE, p0 = EGIM * DERECE;
      const sinp0 = Math.sin(p0), cosp0 = Math.cos(p0);

      // izdüşüm: görünürse [x,y], değilse null
      const izd = (lon, lat) => {
        const l = lon * DERECE - l0, p = lat * DERECE;
        const cosp = Math.cos(p), sinp = Math.sin(p), cosl = Math.cos(l);
        if (sinp0 * sinp + cosp0 * cosp * cosl < 0) return null;
        return [cx + R * cosp * Math.sin(l), cy - R * (cosp0 * sinp - sinp0 * cosp * cosl)];
      };
      const yol = (dizi) => {
        let acik = false;
        for (let i = 0; i < dizi.length; i += 2) {
          const q = izd(dizi[i], dizi[i + 1]);
          if (!q) { acik = false; continue; }
          if (acik) ctx.lineTo(q[0], q[1]); else { ctx.moveTo(q[0], q[1]); acik = true; }
        }
      };

      ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx.clearRect(0, 0, boyut, boyut);

      // küre gövdesi
      const g = ctx.createRadialGradient(cx - R * 0.3, cy - R * 0.35, R * 0.1, cx, cy, R);
      g.addColorStop(0, renk.zemin === "#FFFFFF" ? "#EAF3FA" : "#0B2A44");
      g.addColorStop(1, renk.zemin === "#FFFFFF" ? "#CFE1EE" : "#040A12");
      ctx.beginPath(); ctx.arc(cx, cy, R, 0, 2 * Math.PI); ctx.fillStyle = g; ctx.fill();

      // ağ
      ctx.beginPath(); for (const c of ag) yol(c);
      ctx.strokeStyle = renk.ag; ctx.globalAlpha = kucuk ? 0.55 : 0.45; ctx.lineWidth = kucuk ? 0.6 : 1; ctx.stroke();
      ctx.globalAlpha = 1;

      // kıyı çizgileri (wireframe) + neon parıltı
      ctx.beginPath(); for (const h of halkalar) yol(h);
      ctx.strokeStyle = renk.kara; ctx.lineWidth = kucuk ? 0.9 : Math.max(1.2, boyut / 260); ctx.lineJoin = "round";
      ctx.shadowColor = renk.kara; ctx.shadowBlur = kucuk ? 2 : 6; ctx.stroke(); ctx.shadowBlur = 0;

      // küre sınırı
      ctx.beginPath(); ctx.arc(cx, cy, R, 0, 2 * Math.PI); ctx.strokeStyle = renk.ag; ctx.lineWidth = kucuk ? 1 : 2; ctx.stroke();

      // dış kesikli halka (büyük boyutta, ters yönde döner)
      if (!kucuk) {
        ctx.save(); ctx.translate(cx, cy); ctx.rotate(-zaman / 9000);
        ctx.beginPath(); ctx.arc(0, 0, R + boyut * 0.055, 0, 2 * Math.PI);
        ctx.setLineDash([boyut * 0.02, boyut * 0.035]); ctx.strokeStyle = renk.kara; ctx.lineWidth = Math.max(2, boyut / 110); ctx.stroke();
        ctx.restore(); ctx.setLineDash([]);
      }

      // Türkiye: yanıp sönen neon kırmızı nokta
      const t = izd(TURKIYE[0], TURKIYE[1]);
      if (t) {
        const faz = (zaman % 1600) / 1600;                    // 0 → 1
        const nabiz = 0.5 + 0.5 * Math.sin(faz * 2 * Math.PI);
        const r = kucuk ? 2.2 : Math.max(3.5, boyut / 70);
        // yayılan halka (radar)
        ctx.beginPath(); ctx.arc(t[0], t[1], r + faz * r * (kucuk ? 2.2 : 4), 0, 2 * Math.PI);
        ctx.strokeStyle = renk.nokta; ctx.globalAlpha = 1 - faz; ctx.lineWidth = kucuk ? 0.8 : 1.5; ctx.stroke(); ctx.globalAlpha = 1;
        // çekirdek
        ctx.beginPath(); ctx.arc(t[0], t[1], r * (0.75 + 0.35 * nabiz), 0, 2 * Math.PI);
        ctx.fillStyle = renk.nokta; ctx.shadowColor = renk.nokta; ctx.shadowBlur = (kucuk ? 5 : 14) * (0.4 + nabiz); ctx.fill(); ctx.shadowBlur = 0;
      }
    }

    function dongu(zaman) {
      if (gorunur && !document.hidden) {
        const dt = Math.min(zaman - son, 100);
        if (!azHareket) lambda0 -= dt * (secenek.hiz || 0.012);   // derece / ms (batıdan doğuya dönüş)
        ciz(zaman);
      }
      son = zaman;
      if (!azHareket) requestAnimationFrame(dongu);
    }

    olcekle();
    if (secenek.renk) {
      new MutationObserver(() => { renk = secenek.renk(); ciz(performance.now()); })
        .observe(document.body, { attributes: true, attributeFilter: ["class"] });
    }
    if ("IntersectionObserver" in window) {
      new IntersectionObserver(e => { gorunur = e[0].isIntersecting; }).observe(canvas);
    }
    window.addEventListener("resize", () => { if (!secenek.boyut) { olcekle(); ciz(performance.now()); } });
    ciz(performance.now());
    if (!azHareket) requestAnimationFrame(dongu);
  }

  function baslat() {
    // navbar: logo <img> → canvas
    // Quarto logoyu açık/koyu tema için iki <img> olarak üretir: ilkini canvas yap, diğerlerini kaldır
    document.querySelectorAll(".navbar-brand-logo, .navbar-brand").forEach(a => {
      const imgs = a.querySelectorAll("img.navbar-logo");
      if (!imgs.length) return;
      imgs.forEach((x, i) => { if (i > 0) x.remove(); });
      const img = imgs[0];
      const c = document.createElement("canvas");
      c.className = "navbar-logo recep-kure-canvas";
      c.setAttribute("role", "img");
      c.setAttribute("aria-label", "dönen dünya küresi; Türkiye kırmızı noktayla işaretli");
      const b = Math.round(img.getBoundingClientRect().height) || 46;
      img.replaceWith(c);
      kur(c, { boyut: b, hiz: 0.018 });
    });
    // sayfa içi büyük küre(ler)
    document.querySelectorAll(".recep-kure").forEach(kap => {
      const c = document.createElement("canvas");
      c.setAttribute("role", "img");
      c.setAttribute("aria-label", "dönen dünya küresi; Türkiye kırmızı noktayla işaretli");
      kap.querySelectorAll("img").forEach(i => i.remove());
      kap.appendChild(c);
      kur(c, { hiz: parseFloat(kap.dataset.hiz) || 0.01, renk: cssRenkler });
    });
  }

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", baslat); else baslat();
})();
