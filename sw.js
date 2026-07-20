/* ຄິດໄລ່ໂພຍ — service worker
   ເກັບໄຟລ໌ໄວ້ໃນເຄື່ອງ ເພື່ອໃຫ້ເປີດໃຊ້ໄດ້ ເຖິງບໍ່ມີອິນເຕີເນັດ */
const VERSION = "poy-v1";
const SHELL = VERSION + "-shell";
const RUNTIME = VERSION + "-runtime";

const SHELL_FILES = [
  "./",
  "./index.html",
  "./manifest.webmanifest",
  "./assets/favicon.ico",
  "./assets/favicon-16x16.png",
  "./assets/favicon-32x32.png",
  "./assets/apple-touch-icon.png",
  "./assets/android-chrome-192x192.png",
  "./assets/android-chrome-512x512.png",
  "./assets/maskable-512.png",
];

self.addEventListener("install", (e) => {
  e.waitUntil(
    caches.open(SHELL).then((c) =>
      // ໃສ່ເທື່ອລະໄຟລ໌ ເພື່ອບໍ່ໃຫ້ພັງທັງໝົດ ຖ້າມີໄຟລ໌ໃດໜຶ່ງຫາຍ
      Promise.all(
        SHELL_FILES.map((u) =>
          c.add(new Request(u, { cache: "reload" })).catch(() => null),
        ),
      ).then(() => self.skipWaiting()),
    ),
  );
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches
      .keys()
      .then((keys) =>
        Promise.all(
          keys
            .filter((k) => k !== SHELL && k !== RUNTIME)
            .map((k) => caches.delete(k)),
        ),
      )
      .then(() => self.clients.claim()),
  );
});

self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.method !== "GET") return;

  const url = new URL(req.url);
  const sameOrigin = url.origin === self.location.origin;

  // ໄຟລ໌ລະຫັດ: ຫ້າມເກັບ cache ເດັດຂາດ ຕ້ອງເອົາຈາກເນັດສະເໝີ
  if (
    url.pathname.endsWith("/licenses.json") ||
    url.pathname.endsWith("/owner.html")
  ) {
    e.respondWith(fetch(req, { cache: "no-store" }));
    return;
  }

  // ໜ້າເວັບ: ລອງເອົາຈາກເນັດກ່ອນ ຖ້າບໍ່ໄດ້ຄ່ອຍໃຊ້ຂອງທີ່ເກັບໄວ້
  if (req.mode === "navigate") {
    e.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(SHELL).then((c) => c.put("./index.html", copy));
          return res;
        })
        .catch(() =>
          caches
            .match("./index.html")
            .then((r) => r || caches.match("./") || Response.error()),
        ),
    );
    return;
  }

  // ໄຟລ໌ອື່ນ (ຮູບ, ຟອນ, CDN): ໃຊ້ຂອງທີ່ເກັບໄວ້ກ່ອນ ແລ້ວຄ່ອຍໂຫຼດເກັບໄວ້
  e.respondWith(
    caches.match(req).then((hit) => {
      if (hit) return hit;
      return fetch(req)
        .then((res) => {
          if (res && (res.status === 200 || res.type === "opaque")) {
            const copy = res.clone();
            caches
              .open(sameOrigin ? SHELL : RUNTIME)
              .then((c) => c.put(req, copy))
              .catch(() => {});
          }
          return res;
        })
        .catch(() => hit || Response.error());
    }),
  );
});
