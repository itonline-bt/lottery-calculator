# ໂຄງສ້າງໄຟລ໌ (ຫຼັງແຍກ ຜູ້ໃຊ້ / ຜູ້ດູແລ)

```
lottery-calculator/          ← root ຂອງ repo
│
├── index.html               ← ໜ້າລູກຄ້າ (ຄິດໄລ່ໂພຍ)
├── manifest.webmanifest     ← PWA
├── sw.js                    ← offline cache
├── version.json             ← ບອກເວີຊັນລ່າສຸດ (ບັງຄັບອັບເດດ)
├── licenses.json            ← ຖານຂໍ້ມູນລະຫັດລູກຄ້າ
├── assets/                  ← ໄອຄອນ
│
├── admin/                   ← ສະເພາະເຈົ້າຂອງລະບົບ
│   ├── index.html           ← ລະບົບຈັດການ (nav ຊ້າຍມື · 7 ໜ້າໃນໄຟລ໌ດຽວ)
│   ├── owner.html           ← ລິ້ງເກົ່າ → ພາໄປ index.html#licenses
│   └── dashboard.html       ← ລິ້ງເກົ່າ → ພາໄປ index.html#overview
│
├── START-WINDOWS.bat        ← ເປີດເຊີບເວີໃນເຄື່ອງ
├── server.ps1
└── START-MAC.command
```

## ລິ້ງ

| ໃຜ | ລິ້ງ |
|---|---|
| ລູກຄ້າ | `https://itonline-bt.github.io/lottery-calculator/` |
| ເຈົ້າຂອງ | `https://itonline-bt.github.io/lottery-calculator/admin/` |

## ເປັນຫຍັງຕ້ອງແຍກ

- ຕໍ່ໄປຢາກເພີ່ມໜ້າໃໝ່ໃນຝັ່ງຜູ້ດູແລ ໃສ່ໃນ `admin/` ໄດ້ເລີຍ ບໍ່ປົນກັບໜ້າລູກຄ້າ
- `sw.js` ຂ້າມ cache ທຸກຢ່າງໃນ `admin/` → ແກ້ແລ້ວເຫັນຜົນທັນທີ ບໍ່ຕ້ອງລ້າງ cache
- ຖ້າຕໍ່ໄປຍ້າຍໄປໃຊ້ເຊີບເວີຈິງ ກໍ່ຕັດ `admin/` ອອກມາເປັນຄົນລະລະບົບໄດ້ງ່າຍ

## ຂໍ້ຄວນຮູ້

- **ໜ້າ admin ບໍ່ໄດ້ຖືກເຊື່ອງຈາກຄົນນອກ** — ໃຜກໍ່ເປີດລິ້ງໄດ້ ແຕ່ຕ້ອງມີລະຫັດຜ່ານ
  ຈຶ່ງຈະເຫັນຂໍ້ມູນ. ຄວາມປອດໄພຈິງແມ່ນ: ມີແຕ່ເຈົ້າຂອງເທົ່ານັ້ນທີ່ commit
  `licenses.json` ຂຶ້ນ repo ໄດ້
- ຂໍ້ມູນໃນ Dashboard ອ່ານຈາກ localStorage ຂອງເບຣົາເຊີເຄື່ອງນັ້ນ
  (ຍ້າຍໂຟນເດີບໍ່ມີຜົນ ເພາະ localStorage ຜູກກັບ domain ບໍ່ແມ່ນ path)
- ຢ່າລືມປ່ຽນລະຫັດຜ່ານ `OWNER_HASH` ໃຫ້ຕົງກັນທັງ
  `admin/owner.html` ແລະ `admin/dashboard.html`
