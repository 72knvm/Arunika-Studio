# GAME DESIGN DOCUMENT (DRAFT PRODUKSI v0.2): KALA - SINGKAP GARIS WAKTU

> **Revisi produksi v0.2 — 9 Oktober 2026.** Ketiga dokumen merupakan dokumen kerja yang saling terhubung. Nama file dipertahankan agar referensi mudah dipakai; kata FINAL pada nama file tidak berarti seluruh desain telah dikunci.
> **Status cerita:** draft sekitar 60%, sesuai keterangan pemilik proyek; bukan hasil pengukuran jumlah halaman. Alur, tokoh, dan ending yang sudah ditulis dipertahankan sebagai arah cerita, bukan persetujuan produksi seluruh game.
> **Prioritas saat ini:** prototipe puzzle dua era, kemudian demo Prolog + Act 1. Act 2, Act 3, dan Epilog adalah backlog pengembangan.
> **Status proyek:** dokumen ini tidak membuktikan kode, aset, audio, atau build sudah tersedia. Status siap harus didukung file dan hasil pengujian.

### Acuan bersama dan pengelolaan perubahan

- [GDD_FINAL.md](GDD_FINAL.md): aturan gameplay, kontrol, progresi, scope, dan workflow produksi.
- [KALA_ASSET.md](KALA_ASSET.md): brief visual, spesifikasi ekspor, inventaris, dan pemeriksaan integrasi.
- [STORY_FINAL.md](STORY_FINAL.md): kejadian, dialog, emosi, dan arahan cutscene.
- Jika ketiganya bertentangan, gunakan aturan mekanik demo dalam GDD untuk implementasi; catat konflik naratif/visual untuk diputuskan pemilik proyek. Jangan mengubah lore atau ending secara otomatis.
- Keputusan baru dalam revisi ini adalah **baseline produksi sementara**. Uji dahulu; perubahan ukuran, gaya karakter, atau cakupan tetap dicatat sebelum membuat aset massal.


## 00 — BASELINE PRODUKSI & WORKFLOW

### A. Batas scope dan milestone

| Milestone | Isi | Kriteria selesai |
| :--- | :--- | :--- |
| M0 — Persiapan | Tetapkan versi minor Godot 4.x, GDScript sebagai bahasa awal, resolusi viewport, proporsi karakter, metode animasi, ID scene, dan ukuran pemain | Keputusan tercatat dan proyek kosong bisa dijalankan. Versi minor belum ditentukan oleh dokumen ini. |
| M1 — Prototipe inti | Ruangan uji bendungan Sriwijaya/2150, movement, interaksi hold E, Historical Anchor Q, danau basah/kering, checkpoint | Dengan placeholder, pemain melihat rintangan masa depan, mengubah katup masa lalu, lalu menyeberang di masa depan. Restart tidak menyebabkan state rusak. |
| M2 — Contoh visual | Saka tampak samping, dua lingkungan era, katup, portrait, textbox; integrasi ke ruangan M1 | Skala, posisi kaki, keterbacaan prop, dan komposisi layer cocok di dalam permainan. |
| M3 — Prolog | Kamar, kedai, jembatan, pintu rusun, brankas 2408, countdown 60 detik, mendapat sabuk | Semua scene tersambung; sukses/gagal timer dan pilihan dialog bisa diuji sampai transisi Act 1. |
| M4 — Act 1 awal | Pesisir, Ki Pranata, cover, patroli, QTE detak jantung, Time-Switch | Kedua pilihan Ki Pranata membuka rute yang benar; QTE sukses/gagal dan checkpoint berfungsi. |
| M5 — Act 1 akhir | Gudang/terowongan, bendungan, Maran, kuil, Pasupati, demo clear | Kedua rute mencapai akhir; perubahan kausalitas tersimpan; penghargaan/penalti Maran benar. |
| M6 — QA demo | Playtest penuh, audio, visual, input, ekspor PC | Build hasil ekspor dapat dimulai, diselesaikan, dan diulang tanpa blocker. Durasi 25–30 menit adalah target yang divalidasi lewat playtest, bukan janji. |

M1 adalah ruangan uji terpisah yang memakai sabuk sudah aktif; bukan perubahan urutan cerita. Dalam demo naratif, pemain mendapat sabuk pada akhir Prolog.

Act 2–Epilog, senjata Kunta/Cakra/Tirta, boss Tara, climbing, wall-jump, auto-revive rewind, serta buff lanjutan tidak termasuk M1–M5. Pilihan Prolog yang berpengaruh pada Act 2 tetap disimpan sebagai flag; efeknya belum diimplementasikan di demo.

### B. Aturan mekanik bersama

| Sistem | Baseline v0.2 |
| :--- | :--- |
| Kesehatan Saka | 5 Hati diskret, tanpa pecahan. Damage biasa -1, berat -2; jurang/asam memicu respawn. Angka persen hanya dipakai untuk HP bos, progress UI, dan Kala Influence. |
| Medkit | Maksimum 3 item tersimpan. Stimpack/herbal menambah 1 stok; H/1 mengonsumsi 1 item dan memulihkan 1 Hati hingga batas 5. Jika stok penuh, pickup tetap tersedia; jangan konsumsi medkit saat Hati penuh. |
| Branch 3 Maran | Agresif: kurangi 1 Hati saat ini, tanpa menurunkan maksimum. Fokus Tara: berikan 1 stok medkit, tanpa menambah kapasitas. Jika stok penuh, reward tetap tersedia untuk diambil. |
| Branch 2 Ki Pranata | Rute darat sulit: total 6 penjaga (4 dasar + 2 tambahan). Rute peta: drainase kanan–kiri–kanan, menuju puzzle bendungan yang sama. |
| QTE dan input kontekstual | E digunakan oleh konteks aktif saja. Urutan: modal/QTE → cutscene/dialog → cover → interaksi dunia. Space pada dialog tidak sekaligus melompat; klik kiri pada QTE tidak sekaligus menyerang. |
| Time-Switch | Hanya pada Historical Anchor. Validasi tempat mendarat di era tujuan sebelum perpindahan. Jika tertutup collision atau tidak aman, tolak dan beri feedback; jangan memindahkan pemain ke dalam objek. |
| Kausalitas | Flag `dam_diverted` mengubah kondisi danau 2150. Pergantian era tidak menghapus perubahan puzzle atau pilihan dialog. |
| Checkpoint | Simpan scene, posisi aman, era, Hati, stok medkit, unlock, flag puzzle dan dialog. Saat gagal, pulihkan snapshot checkpoint secara utuh. Save ke disk dapat ditambahkan setelah alur checkpoint stabil. |
| Branch 1, backlog | Pilihan jujur: baseline buff +1 Hati setelah 10 detik di awal boss Act 2, sekali per percobaan, maksimal 5. Perlu playtest; tidak aktif dalam demo. |
| Branch 4, backlog | Auto-revive satu kali, kembali 5 detik dan pulih 3 Hati. Perlu desain rekaman state sebelum implementasi; checkpoint biasa tidak dianggap sama dengan rewind. |
| Branch 7, backlog | Penalti QTE -2 Hati. Angka balans lanjutan dapat berubah setelah prototipe boss. |

### C. Siklus kerja per scene

1. Pilih satu scene dan tulis brief: ID, tujuan pemain, input, objek, urutan kejadian, flag masuk/keluar, dan kondisi sukses/gagal.
2. Codex membuat versi playable dengan placeholder; implementasikan satu fitur yang bisa diuji per tugas.
3. Setelah layout stabil, buat brief aset pixel art menurut KALA_ASSET.md. Tim menggunakan moodboard untuk menentukan suasana, palet, dan komposisi; aset final dibuat oleh illustrator sesuai aturan tugas.
4. Illustrator memproduksi dan merapikan sprite: alpha, layer, skala, penamaan, serta animasi. Gambar utuh belum otomatis menjadi rig/spritesheet siap pakai. Sumber dan hak penggunaan aset dicatat.
5. Codex mengintegrasikan aset, collision, UI, VFX, serta audio yang sudah tersedia.
6. Tim menguji di Godot dan build ekspor; catat bug/hasil tes. Status selesai diberikan setelah integrasi teruji.
7. Update tracker, ketiga dokumen bila aturan berubah, dan checkpoint Git sebelum lanjut scene lain.

### D. Struktur proyek dan sinkronisasi

```text
project.godot
docs/
  GDD_FINAL.md
  KALA_ASSET.md
  STORY_FINAL.md
  PRODUCTION_TRACKER.md
assets/
  sprites/backgrounds/
  sprites/characters/
  sprites/props/
  sprites/ui/
  shaders/
  audio/sfx/
  audio/bgm/
scenes/
  prototypes/
  prolog/
  act1/
  shared/
scripts/
data/dialogue/
```

Struktur di atas adalah rencana folder proyek; revisi dokumen ini tidak membuat proyek Godot atau tracker terpisah. Folder `Arunika Studio` saat ini berisi tiga dokumen revisi.

Salinan `docs/` dalam proyek menjadi acuan tim. Unggah versi yang sama ke Project ChatGPT ketika berubah; percakapan ChatGPT dan Codex tidak dianggap otomatis tersinkron. Gunakan Git untuk kode/dokumen, dan simpan sumber ilustrasi beserta ekspornya agar revisi dapat dilacak.

Tracker dapat dimulai dengan format berikut; tidak ada pekerjaan yang dinyatakan selesai tanpa verifikasi.

| ID | Scene | Tugas/aset | Dependensi | PIC | Status | Bukti uji |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `sys_time_switch` | `proto_dam` | Perpindahan era aman | Movement, layout dua era | Marvin/Falent | Draft | Belum diuji |
| `prop_dam_crane_valve` | `act1_03` | Katup dan interaksi | Brief ukuran, hold E | Arif + programmer | Draft | Belum diuji |
| `dlg_ki_pranata_01` | `act1_01` | Cabang dan flag rute | Dialog data | Tim | Draft | Belum diuji |

Status: Draft → Siap dikerjakan → Dikerjakan → Siap integrasi → Terintegrasi → Teruji. Gunakan status Blocked beserta alasan jika ada dependensi belum selesai.

### E. Brief tugas Codex dan batas perubahan

> Baca ketiga dokumen dalam docs/. Gunakan versi Godot yang ditetapkan proyek. Kerjakan hanya [ID tugas] untuk [ID scene], sesuai baseline mekanik v0.2. Gunakan placeholder bila aset belum tersedia. Kriteria selesai: [hasil yang dapat diuji]. Laporkan file yang berubah, pemeriksaan yang dijalankan, dan hal yang belum bisa diuji. Jika dokumen konflik, catat konfliknya; jangan mengarang kelanjutan cerita.

Pilihan model merupakan preferensi kerja, bukan dependensi proyek: GPT-6.1 Sol Medium untuk tugas rutin, High untuk sistem saling terhubung, Astra High untuk perencanaan atau diagnosis sulit. Ultra dipakai hanya untuk bagian independen yang pembagian file dan integrasinya jelas.

### F. Catatan revisi dan keputusan terbuka

- v0.2: membatasi produksi aktif ke prototipe dan demo; menyelaraskan Hati/medkit, jumlah penjaga, ID scene, status aset, serta alur ChatGPT–Codex–Godot.
- Masih terbuka: versi minor Godot, metode animasi final, proporsi karakter final, spesifikasi perangkat target, dan deadline. M0 menyelesaikan keputusan teknis sebelum produksi massal.
- Cerita late-game, balans boss, teknologi rewind, dan keakuratan detail budaya perlu tinjauan lanjutan. Tidak ada bagian baru cerita yang dibuat dalam revisi ini.

---

**Judul produksi: KALA — Singkap Garis Waktu. SAKA merupakan working title sebelumnya.**  
**Developer:** Arunika Studio  
**Tim & Role:**  
1. **Marvin Karyanda (123140185)** — Game Designer, Programmer, Tester  
2. **Muhamad Arif Ardani (123140186)** — Illustrator, Sound Engineer, Tester  
3. **Falent Antonius Panjaitan (123140124)** — Sound Engineer, Programmer, Tester  
**Mata Kuliah:** Pengembangan Game (Teknik Informatika ITERA)  
**Target Engine:** Godot Engine 4.x (2D Narrative Puzzle-Platformer / Metroidvania-lite)

---

## 01 — EXECUTIVE SUMMARY & CORE CONCEPT

* **Judul Game:** KALA: Singkap Garis Waktu
* **Genre:** 2D Puzzle-Platformer, Metroidvania-lite, Narrative Adventure
* **Sub-genre:** Sci-Fi Time Travel, Nusantara Mythological Fantasy
* **Platform:** PC (Godot 4)
* **Arah Visual:** 2D pixel art dengan animasi sprite dan background parallax. Referensi: Tales of the Neon Sea untuk lingkungan kota pixel dan pencahayaan, A Space for the Unbound untuk suasana Indonesia serta ekspresi karakter, dan Cyberpunk 2077 untuk atmosfer teknologi yang diterjemahkan ke 2D.
* **Palet Prolog:** Pagi Astanapura memakai langit oranye dan cahaya keemasan, bangunan/interior biru gelap, serta cyan sebagai aksen teknologi. Kamar lebih redup; skybridge dan kedai terasa terang serta hangat. Ungu–hitam menandai gangguan Kala saat tragedi. Palet mengikuti lokasi dan suasana adegan, bukan era saja; magenta bukan warna dominan Prolog.
* **Target Audience:** Remaja hingga dewasa muda (13–24 tahun)
* **Core Concept:**  
  Pemain mengendalikan **Saka (25)**, seorang arkeo-mekanik independen berbekal implan mata bionik (*Arkeo-Optics*) dan sabuk distorsi kronal (*Chronos-Belt*), yang menavigasi sejarah peradaban Nusantara melalui titik-titik *Historical Anchor*. Misinya adalah memecahkan teka-teki temporal antarzaman (*Temporal Puzzles*) demi menyelamatkan adik perempuannya, **Tara (17)**, dari cengkeraman entitas kosmik non-linear purba bernama **Sang Hyang Kala**, tanpa menghancurkan tatanan kausalitas garis waktu itu sendiri.

---

## 02 — DESIGN PILLARS (PONDASI UTAMA)

1. **Causality is King (Satu Garis Waktu Murni):**  
   Setiap tindakan di masa lalu memiliki dampak langsung dan logis pada masa depan (*Single Continuum*). Tidak ada jalan pintas dimensi paralel.
2. **Earned Knowledge (Pengetahuan dari Eksplorasi):**  
   Saka dan pemain belajar bersama memahami rahasia teknologi purba melalui pemindaian *Arkeo-Optics*, arsip lontar leluhur, dan dialog reaktif antartokoh.
3. **Nusantara as Foundation (Keaslian Sejarah & Budaya):**  
   Latar sejarah (Sriwijaya, Padjadjaran, Majapahit, Mataram Kuno) direpresentasikan dengan keakuratan budaya dan arsitektur otentik, sedangkan mitologi lokal diintegrasikan sebagai lapisan kosmologi fiksi ilmiah futuristik.
4. **Emotional Anchor (Ikatan Persaudaraan Saka & Tara):**  
   Motivasi penggerak cerita bertumpu pada cinta dan tanggung jawab seorang kakak kepada adik perempuannya, bukan sekadar trope klise pahlawan penyelamat dunia generik.

---

## 03 — KOSMOLOGI, ATURAN WAKTU, & RESOLUSI PARADOKS

### A. Kosmologi Dunia & Sang Hyang Kala
* **Single Continuum (The Sacred River of Time):** Waktu mengalir layaknya satu sungai besar.
* **Sang Hyang Kala (Non-Linear Entity):** Anomali kosmik di luar ruang-waktu 3 dimensi yang memangsa garis waktu. Kala tidak memiliki raga fisik mandiri; ia membutuhkan wadah (*Vessel*) dari garis darah "Penjaga Murni" untuk bermanifestasi.
* **Root Erasure (Pemusnahan di Singularity):** Kala dieksekusi di *Singularity Void* menggunakan *Senjata Pemutus Waktu*, menghapus eksistensinya dari akar semesta (Past, Present, Future). Ini **memutus siklus infinite loop secara permanen**.

### B. Resolusi Paradoks & Medan Insulasi Chronos-Belt
* **Prinsip Quantum Anchor:** Sabuk *Chronos-Belt* memancarkan medan insulasi kronal mikro. Saat *Time Reset* memulihkan dunia, Saka dan sabuknya terlindungi dalam gelembung kuantum sehingga **tidak terhapus dari eksistensi**.
* **Status Anomali:** Saka selamat di garis waktu baru 2150, namun status sosialnya terhapus dari catatan sipil dan ingatan keluarga. Saka menjadi pengamat abadi (*The Living Anomaly*) bersama Maran.

---

## 04 — CHARACTER BIBLE & PROFIL TOKOH

1. **Saka (25 Tahun, Tinggi: 184 cm):** Protagonis. Arkeo-mekanik mandiri asal Astanapura (2150) dengan implan mata bionik (*Arkeo-Optics*). Cerdas, analitis, protektif, tekun, dan rela menyeberangi batas zaman demi Tara.
2. **Tara (17 Tahun, Tinggi: 163 cm):** Adik perempuan Saka (Adek • Sahabat • Alasan). Ceria, tangguh, perhatian, keras kepala, selalu mengenakan liontin pemberian Saka, dan merupakan pewaris genetik darah murni penjaga waktu (*The Vessel Target*).
3. **Ki Pranata (60 Tahun):** Tetua pembuat perahu pesisir Wanua Sriwijaya abad ke-7. Bijak, hangat, dan paham seluk-beluk pelabuhan.
4. **Maran (The Anomaly / Sang Pengamat Abadi):** Pria misterius berjas usang dengan buku catatan kulit. Muncul di tahun 2150 (berbekal senjata pipa) dan di tebing Padjadjaran mengamati deviasi waktu. Terikat kode etik non-intervensi Ordo Pengamat.
5. **Sang Hyang Kala / Utusan Kala:** Entitas kosmik pemangsa siklus waktu ribuan tahun.

---

## 05 — SISTEM 5 VISUAL STATE SANG ADIK (VESSEL PROGRESSION)

| Tahap | Nama State | Karakteristik Visual & Emosional | Kemunculan di Game |
| :---: | :--- | :--- | :--- |
| **Stage 1** | **Tara Normal** | Gadis ceria, pakaian kasual 2150, hangat, cerewet menyuruh Saka sarapan & istirahat. | Prolog (Kamar & Jembatan) & Epilog |
| **Stage 2** | **Possessed Awakening** | Awal manifestasi melayang sekitar 20 cm, lalu terangkat tinggi pada klimaks jembatan, **Pose Maestro (kedua tangan terentang lebar)**, mata menyala ungu, retakan hitam di kulit. | Prolog (Tragedi Jembatan) |
| **Stage 3** | **Half Vessel** | Sebagian tubuh terbungkus kristal bayangan Kala, kesadaran tumpang tindih, suara terdistorsi ganda. | Act 2 (Kanal Megalopolis Majapahit) |
| **Stage 4** | **Full Vessel (Boss)** | Wujud tempur lengkap Kala mengendalikan raga Tara, aura raksasa kosmik, mata tanpa pupil. | Act 3 (Phase 1 Final Boss) |
| **Stage 5** | **Separated / Weakened** | Tubuh kembali normal setelah ikatan benang waktu diputus oleh Cakra, pingsan aman di pelukan Saka. | Act 3 (Phase 2 & Epilog) |

---

## 06 — PETA PROGRESI 5 BAGIAN & SISTEM PUSAKA NUSANTARA

```
[PROLOG] "Ketika Dewa Turun" — Astanapura 2150 (Sektor Rusunawa & Jembatan)
   │  ├─ Gameplay: Solder modul konektor kabel di meja, Tutorial Scan (F), Gerak (A/D), Sprint (Shift), Jump/Slide (Space/Ctrl), Mash Pintu Rusun (Rapid Tap E), Countdown Hectic 60s & Keypad 4-Digit Brankas Kakek (2408 - Ultah Tara), Inisiasi Sabuk (Hold E)
   │  ├─ Branch 1 (Saka & Tara): Protektif (Echo Sedih di Act 2) vs Jujur (Buff Regen +1 Hati setelah 10 detik di awal boss Act 2 (baseline sementara))
   │  └─ Tragedi: Langit Robek ➔ Tara Kerasukan (Pose Maestro) ➔ Platforming Puing Melayang ➔ Retakan Waktu Menelan Tara ➔ Dobrak Rusunawa ➔ Loncatan Kronal 682 M
   ▼
[ACT 1] "Jejak yang Tertinggal" — Pesisir Wanua Sriwijaya (682 M) & Reruntuhan 2150
   │  ├─ Tema Visual: Pantai Pasir Putih, Hutan Bakau, Dermaga Sriwijaya vs Reruntuhan Asap 2150
   │  ├─ Gameplay: Eksplorasi Pesisir & Interaksi NPC ➔ Penyamaran Jarik (Ki Pranata) ➔ Stealth Stage 1 (E) ➔ Eureka Time-Switch (Q) ➔ Stealth Stage 2 & Terowongan Lontar (M) ➔ Puzzle Kausalitas Bendungan vs Danau Asam ➔ Temu Maran ➔ Altar Kuil 2150: QTE Evasion [Space] + Platforming Koridor Retak & Mid-Air Monster Vault [Space] + Maran Background/Foreground Cover ➔ Pull Pasupati [Hold E] & First Melee Finisher [J]
   │  ├─ Branch 2 (Ki Pranata): Intimidasi (+2 Musuh Stealth / Total 6 Penjaga) vs Diplomatis (Dapat [Peta Lontar Tua] Bypass Terowongan Stage 2 Stealth)
   │  ├─ Branch 3 (Maran 2150): Agresif (Ditembak Maran -1 Hati saat ini; maksimum tetap 5) vs Fokus Tara (Dapat [Stimpack Medis] +1 stok medkit; kapasitas tetap 3)
   │  └─ Unlock Pusaka 1: KERIS PASUPATI (Melee Attack [J], Tebasan Api Spiritual)
   ▼
[ACT 2] "Rimba Kausalitas & Sang Pengamat" — Rimba Padjadjaran & Megalopolis Majapahit (Abad 14–15)
   │  ├─ Tema Visual: Rimba Hutan Tropis Padjadjaran, Relief Candi Megalitikum, Lab Geotermal 2150, Kanal Megah Majapahit & Pipa Maglev 2150
   │  │
   │  ├─ [PHASE 1: RIMBA PURBA PADJADJARAN (ABAD KE-14 ↔ LAB GEOTERMAL 2150)]
   │  │   ├─ SCENE 1: Lembah Curug Berbisik (Pendaratan & Dual-Stance Combat/Stealth)
   │  │   │   ├─ Bagian A: Pendaratan jatuh dari portal ("terlempar dari atas Rusunawa"), mencari Maran, scan otomatis Arkeo-Optics [F] (Kalibrasi Abad 14 & lacak residu ungu Tara).
   │  │   │   ├─ Bagian B: Scavenging Lingkungan — Rimpang Herbal Purba (menambah 1 stok medkit; penggunaan memulihkan 1 Hati) vs Stimpack 2150 (+1 Hati saat digunakan; kapasitas stok tetap 3).
   │  │   │   └─ Bagian C: Sentinel Anomali Purba — Cover semak [E], Danger Zone Heartbeat QTE saat musuh menginspeksi semak, lalu eksekusi Pasupati Silent Strike [E] (Radial Ring QTE 360° 1-Hit Kill) saat musuh berbalik badan vs Stance A (Open Melee Pasupati [J] 4-6 Hit).
   │  │   │
   │  │   ├─ SCENE 2: Ngarai Kabut & Sisa Pondok Pemburu Kuno
   │  │   │   ├─ Bagian A: Pendakian tebing terjal ➔ Rangkaian 4 lompatan batu cadas berirama ➔ Panjat sulur akar gantung (Climbing Vines) ➔ Scan jejak cakaran kuku Tara di tebing.
   │  │   │   ├─ Bagian B: Saung panggung pemburu porak-poranda ➔ Looting & Equip [Rompi Kulit Pemburu Padjadjaran] (Ganti outfit dari kain jarik yang kedinginan) ➔ Scan lontar kulit kayu aksara Sunda Kuno (Lore "Bayangan Hitam Pemangsa Darah Suci").
   │  │   │   ├─ Bagian C: Pelataran berbatu & 2 Sentinel Anomali ➔ Taktik panjat akar gantung ke dahan pohon beringin raksasa (High-Ground Vantage Point).
   │  │   │   └─ Bagian D: Eksekusi Air-Drop Silent Strike [E] dari dahan pohon (Sweet Spot 1.5x lebih lebar) ➔ Double clean takedown menuju celah hulu curug.
   │  │   │
   │  │   ├─ SCENE 3: Jurang Reaktor Geotermal 2150 & Puzzle Kausalitas Beringin Silika
   │  │   │   ├─ Tahap 1 (2150): Jurang reaktor plasma mematikan & lantai listrik jutaan volt (Scan F: butuh jembatan silika).
   │  │   │   ├─ Tahap 2 (Abad 14): Mendaki ke hulu curug, tebas batu longsor [J] ➔ Air curug mengaliri bibit beringin purba.
   │  │   │   └─ Tahap 3 (2150): 700 tahun berlalu, terbentuk Jembatan Akar Fosil Silika anti-listrik ➔ Wall-Jump ke lantai 2 pabrik.
   │  │   │
   │  │   ├─ SCENE 4: Lab Terbengkalai Sektor 7 & Wasiat Kakek Wikana
   │  │   │   ├─ Bagian A: Eksplorasi lab berdebu 2150, meja solder tua, looting Stimpack Medis 2150.
   │  │   │   └─ Bagian B: Audio Log #087 Dr. Raden Wikana (2148) ➔ Penyesalan soal Tara, wasiat keluarga, & Unduh Frekuensi 432 Hz (`Chronos_Resonance_432Hz.dat`).
   │  │   │
   │  │   └─ SCENE 5: Punden Berundak, The Bootstrap Paradox, & Maran di Tebing
   │  │       ├─ Bagian A: Resonansi gelombang 432 Hz di lempeng tembaga membuka gerbang Punden Berundak.
   │  │       ├─ Bagian B: Cutscene Flashback Arkeo-Optics ➔ Empu Padjadjaran menggambar lontar sabuk waktu setelah melihat Saka dari masa depan (*Bootstrap Paradox*).
   │  │       └─ Bagian C: Branch 4 (Maran di Tebing): Ancam Pasupati (Hazard Angin Puyuh Kronal) vs Empatik/Hormat (Dapat [Kapsul Kronal Maran] 1x Auto-Revive 3 Hati + Rewind 5s (backlog, memerlukan prototipe rekaman state)).
   │  │
   │  ├─ [PHASE 2: MEGALOPOLIS MAJAPAHIT (ABAD KE-15 ↔ KANAL MAGLEV 2150)]
   │  │   ├─ SCENE 6: Gerbang Kota Bata Merah Majapahit & Badai Singularitas Ungu (Auto-scroll chase 4.5 m/s)
   │  │   ├─ SCENE 7: Blind Leap Platforming di Kanal Air & Pipa Maglev 2150 (Time-Switch Q di udara)
   │  │   ├─ SCENE 8: Reruntuhan Bengkel Pandai Besi & Klaim Pusaka 2: TOMBAK KUNTA [K] (Heavy Kinetic Burst)
   │  │   ├─ SCENE 9: Menembus Barikade Gerbang Bendungan Raksasa dengan Ledakan Kunta
   │  │   └─ SCENE 10: Puncak Bendungan Kanal Melayang — Boss Fight TARA HALF-VESSEL
   │  │       ├─ Wujud Setengah Manusia & Suara Ganda Binaural ➔ Branch 5: Hina Kala (Hard Mode +15% Speed) vs Panggil Nama Tara (Tara tahan diri 4s, -10% HP Bos).
   │  │       ├─ Phase 1 (Shield & Spores: Kunta + Pasupati) ➔ Phase 2 (Anti-Gravity & Floor Annihilation Beam: Time-Switch [Q] ke gerbong maglev melayang).
   │  │       ├─ Unlock Pusaka 3: CAKRA BASUNANDA (Pemotong Benang Takdir).
   │  │       └─ Batara Kala menarik Tara ke Kawah Purba Mataram Kuno Abad ke-9 (Act 3). Saka melompat mengejar!
   ▼
[ACT 3 - CLIMAX] "The Temporal Sanctum" — Kawah Mataram Kuno (Abad ke-9) & Singularity Void
   │  ├─ Tema Visual: Kawah Vulkanik Lahar Obsidian ➔ Tabrakan Seluruh Era di Dimensi Singularity
   │  ├─ Gameplay: Ruwatan Altar Kala ➔ Penurunan Kala Influence % ➔ Unlock Pusaka 4: TIRTA AMERTA (Healing)
   │  ├─ Branch 6 (Altar Ruwatan): Brute Force Kunta (-30% Influence + Ambush 2 Menit) vs Purifikasi Arkeo-Optics (-20% Influence + Tirta Amerta Buff Pasif)
   │  ├─ Multi-Phase Boss Fight:
   │  │   ├─ Phase 1: Boss Tara (Full Vessel Form)
   │  │   ├─ Phase 2: The Separation (Cakra Basunanda) ➔ Branch 7 (QTE Ragu -2 Hati vs Teguh Resolve + Instan Full Charge Ultimate)
   │  │   └─ Phase 3: True Form SANG HYANG KALA (Raksasa Kosmik Purba)
   │  └─ Eksekusi Akhir: Memotong eksistensi Kala dengan SENJATA PEMUTUS WAKTU
   ▼
[EPILOG] "The Bittersweet Reset" (Fajar Arunika) — Astanapura 2150 (Baseline Timeline)
   │  ├─ POV Flip Tara: Tara terbangun pagi sendirian di kamar apartemen damai ➔ Sarapan tenang ➔ Jalan di jembatan bersama teman-temannya.
   │  ├─ Momen Puncak: Tara berpapasan dengan Saka di jembatan layaknya orang asing. Saka tersenyum haru: "Jaga diri baik-baik ya, Tara."
   │  ├─ Pertemuan Maran: Maran menyambut Saka ke dalam Ordo Pengamat Waktu.
   │  └─ Tagline Penutup: “Tidak semua yang hilang harus ditemukan kembali.”
```

---

## 07 — SISTEM 7 INTERACTIVE DIALOGUE BRANCHING (MATRIKS KONSEKUENSI)

| Node Dialog | Pilihan A | Pilihan B | Konsekuensi Pilihan A | Konsekuensi Pilihan B |
| :--- | :--- | :--- | :--- | :--- |
| **Branch 1 (Prolog)** | *"Paling cuma rongsokan lama, Dek."* (Protektif) | *"Di catatan Kakek, sabuk yang kekunci di brankas itu dirancang buat lindungin keluarga kita."* (Jujur) | Gema suara Tara di Act 2 terdengar sedih & kesepian (*Emotional Echo*). | Gema suara Tara di Act 2 memberi **Buff Pasif Regenerasi Hati** saat boss fight. |
| **Branch 2 (Act 1 - Ki Pranata)** | *"Saya saudagar kaya karam, jangan banyak tanya!"* (Bohong) | *"Saya musafir tersesat, tolong bantu saya, Kek."* (Sopan) | **Rute Sulit (Stealth Darat):** Melewati area gudang terbuka dengan patroli padat (**6 Prajurit Total (4 dasar + 2 tambahan)**), memanfaatkan kolong peti & balik terpal rempah. | **Jalur Pintas Cerdas (Terowongan Bawah Tanah):** Mendapatkan `[Peta Lontar Tua]` yang membuka rute terowongan drainase dengan **3 Persimpangan Cabang Navigasi `[M]`** untuk mem-bypass 100% penjaga atas. |
| **Branch 3 (Act 1 - Maran 2150)** | *"Nyingkir! Aku gak punya waktu!"* (Agresif/Timeout) | *"Turunkan senjata, aku mau selamatkan adikku!"* (Fokus Tara) | Maran menembak bahu Saka; **Kehilangan 1 Hati (Status Penalty)** saat masuk Kuil. | Maran bongkar rahasia Vessel & memberi **`[Stimpack Medis 2150]` (Menambah 1 stok medkit, kapasitas tetap 3)**. |
| **Branch 4 (Act 2 - Maran Tebing)** | *"Siapa kau?! Bekerja untuk dewa itu?!"* (Ancam) | *"Apa yang kauketahui tentang deviasi waktu ini?"* (Hormat) | Maran lenyap; memicu **Hazard Angin Puyuh Temporal** (Platforming tebing sulit). | Maran memberi **`[Kapsul Kronal Maran]` (Fitur Revive 1x)**: Jika Hati Saka habis di Act 2, waktu mundur 5 detik & pulihkan **3 Hati** secara otomatis. |
| **Branch 5 (Act 2 - Tara Half-Vessel)** | *"Keluarlah dari tubuh adikku, parasit!"* (Marah) | *"Tara, lawan dia! Ingat janji pantai kita!"* (Emosional) | **Hard Mode:** Proyektil Kala lebih cepat 15%; fase pengejaran lebih agresif. | **Easy Mode:** Kesadaran Tara menahan tubuh 4s; **celah serangan bebas (-10% HP Bos)**. |
| **Branch 6 (Act 3 - Altar Mataram)** | Ledakkan Altar dengan Kunta (Brute Force) | Pecahkan Puzzle Ukiran Batu (Purifikasi) | Penurunan Kala Influence cepat (-30%), namun diserbu Ambush Elit selama 2 menit. | Penurunan Kala Influence stabil (-20%), aman tanpa Ambush, Tirta Amerta dapat pasif regen. |
| **Branch 7 (Act 3 - Final QTE)** | Ragu-ragu melihat wajah Tara yang kesakitan | Teguh Pendirian memotong benang waktu | QTE sempit (0.5s); ledakan balik gravitasi memotong **2 Hati** sebelum Phase 3. | QTE sempurna; Tara terbebas bersih; Ultimate Attack instan terisi penuh 100%. |

---

## 08 — SISTEM MEKANIK GAMEPLAY: STEALTH, KESEHATAN, & DISTORSI TEMPORAL

### A. Sistem Persembunyian Objek (Cover System) & AI Patroli
1. **Mekanik Masuk & Sembunyi (`[E]`):**
   * **Variasi Objek Cover:**
     * *Area Luar / Pesisir / Hutan:* Rumpun **Semak Ilalang**.
     * *Area Indoor / Kompleks Pergudangan:* **Kolong Rak Peti Kayu Manis** & **Balik Kain Terpal Goni Rempah**.
   * Pemain menekan `[E]` saat berada di dekat objek cover untuk masuk ke dalam mode bersembunyi (*Hiding State*).
   * Sprite Saka berubah menjadi siluet gelap semi-transparan (*Opacity 50% / Modulate Alpha*) menandakan Saka tidak terlihat oleh penglihatan normal musuh.
   * **Tombol Keluar (`[Space]`):** Pemain dapat menekan tombol `[Space]` kapan saja untuk melompat/keluar dari semak, kolong peti, atau balik terpal secara instan saat kondisi sekitar dinilai aman.
2. **AI State Machine Penjaga Patroli (3 State):**
   * **State 1: Patroli Normal (Cone Hijau):** Prajurit berjalan menyusuri lintasan waypoint berulang dengan kecepatan stabil.
   * **State 2: Danger Zone / Mencurigakan (Cone Kuning - Berhenti):** Prajurit berhenti tepat di depan objek persembunyian Saka selama 3–4 detik untuk menginspeksi goyangan kain/daun atau derak langkah kaki. **Memicu Mini-Game Detak Jantung / Tahan Napas**.
   * **State 3: Terdeteksi Penuh / Alarm (Cone Merah - Tanda Seru `!`):** Deteksi visual penuh. Prajurit membunyikan trompet/kentongan tanduk, mengejar Saka, dan langsung menyerang (*Instan Reload Checkpoint* jika belum memiliki senjata pusaka).

---

### B. Mini-Game Detak Jantung & Tahan Napas (Danger Zone Heartbeat Skill Check)
* **Tujuan Desain:** Menghadirkan ketegangan imersif ala thriller saat prajurit musuh berdiri tepat beberapa jengkal di depan objek persembunyian tanpa membebani pemain dengan fatigue konstan (QTE hanya terpicu jika musuh berhenti di depan objek, bukan saat sembunyi biasa).
* **Efek Audio-Visual Immersion:**
  * **Audio:** BGM utama meredup drastis dengan filter akustik *Low-Pass*, terdengar suara detak jantung mendentum kencang (*Thump-thump... thump-thump...*) diiringi helaan napas tertahan Saka.
  * **HUD / UI:** Meteran bar horizontal (*Timing Bar*) muncul melayang di atas kepala Saka. Sebuah jarum penunjuk bergerak berosilasi bolak-balik melintasi area target hijau (*Sweet Spot*).
* **Skema Input Kontrol:**
  * Pemain menekan `[Klik Kiri]` atau `[E]` tepat saat jarum penunjuk berada di dalam zona hijau (*Sweet Spot*).
* **Konsekuensi & Evaluasi:**
  * **SUCCESS (Timing Tepat di Sweet Spot):** Saka berhasil menahan napas dan meredam debar jantungnya. Prajurit menghela napas (*"Cuma hembusan angin..."* / *"Musang liar rupanya..."*), lalu berputar balik dan melanjutkan rute patrolinya.
  * **FAILURE (Meleset / Terlambat):** Saka tersedak batuk atau menginjak kayu rapuh (*CRACK!*). Saka otomatis terlempar/terdorong keluar dari cover, status stealth gagal seketika (*ALERT MERAH*), prajurit langsung menghunus tombak ke arah Saka.

---

### C. Integrasi Percabangan Cerita, Puzzle Kausalitas, & Zona Resonansi (Historical Anchor)
1. **Branch 2 Payoff (Ki Pranata) & Sistem Navigasi Terowongan Bawah Tanah:**
   * **Pilihan B (Sopan - `[Peta Lontar Tua]`):** Membuka kisi besi saluran drainase bawah tanah kuno Sriwijaya.
     * **Mekanik Navigasi Peta Lontar (`[M]`):** Pemain menekan `[M]` untuk melihat denah sketsa tinta lontar kuno.
     * **Puzzle 3 Persimpangan Cabang:**
       * *Persimpangan 1:* **Belok Kanan (BENAR - Saluran Air Bersih)** vs Belok Kiri (SALAH - Palka Gudang Senjata / Busted).
       * *Persimpangan 2:* **Belok Kiri (BENAR - Ventilasi Kering)** vs Lurus (SALAH - Buangan Muara Rawa Buaya / Busted).
       * *Persimpangan 3:* **Belok Kanan (BENAR - Pintu Air Tepi Kanal / Exit)** vs Lurus (SALAH - Barak Prajurit / Busted).
     * **Immersion:** Setiap persimpangan diiringi dialog *Floating Bubble Chat* monolog taktis Saka mendengarkan suara langkah dan aliran air.
   * **Pilihan A (Sombong/Intimidasi - Rute Darat):** Pemain melewati Stage 2 Pergudangan Darat dengan jumlah penjaga bertambah menjadi **6 Prajurit Patroli** (dibandingkan 4 prajurit default) dengan mekanik cover kolong peti & balik terpal rempah yang sama.
2. **Puzzle Kausalitas Bendungan Sriwijaya (682 M ↔ 2150):**
   * **Fase 1 (Pemicu):** Saka mendeteksi sinyal resonansi Tara berasal dari reruntuhan kuil sisi 2150. Sabuk Chronos-Belt aktif $\rightarrow$ Saka melompat ke 2150 (`[Q]`).
   * **Fase 2 (Rintangan & Analisis):** Di 2150, lembah menuju kuil tenggelam oleh Danau Limbah Asam (korosi 98%). Pemindaian `[F]` mengungkap bahwa danau terisi oleh aliran sungai purba sejak 682 M.
   * **Fase 3 (Manipulasi Sebab-Akibat):** Saka kembali ke 682 M (`[Q]`), memanjat menara bendungan dan menahan `[E]` untuk mengalihkan debit sungai langsung ke laut lepas. Kausalitas 2150 seketika berubah: Danau limbah asam surut mengering total menjadi lembah berbatu tandus yang aman diseberangi menuju Scene 4 (Maran).
3. **Mekanik Kontekstual Time-Switch & Anti-Exploit (Historical Anchor Only):**
   * **Aturan Dunia & Karakter:** Saka merakit sabuk murni mengikuti cetak biru peninggalan kakeknya tanpa memahami penuh teori kuantumnya. Sabuk hanya dapat memicu distorsi temporal lokal pada titik koordinat yang memiliki medan resonansi waktu stabil (*Historical Anchor* / `can_time_switch = true`).
   * **Rejection Feedback (Jika Pemain Menekan `[Q]` di Luar Zona):**
     * *SFX:* Suara roda gigi sabuk macet (*BZZT-KLIK*).
     * *HUD / LED:* Lampu LED sabuk berkedip kuning-merah (*No Signal*).
     * *Floating Bubble Saka:* Memberikan dialog reaktif (contoh: *"Roda giginya macet... Nggak ada resonansi kronal di sini. Sabuk ini cuma bisa aktif di titik-titik jangkar tertentu."*). Hal ini mencegah pemain menyalahgunakan Time-Switch untuk mem-bypass stage sembarangan.

---

### D. Sistem Kesehatan Hati (Discrete Heart System) & Manajemen Medkit (HUD)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ [MINIMALIST DIEGETIC TOP-LEFT HUD OVERLAY]                                  │
│                                                                             │
│  [❤️] [❤️] [❤️] [❤️] [💔]  ➔ 5 Node Hati Kronal (Sisa 4 Hati)                │
│                                                                             │
│  [💊] [💊] [⚪]             ➔ 3 Slot Medkit Maksimal (Tersedia 2)            │
│  [Tombol H / 1]                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

1. **Struktur Hati (Discrete Chrono-Hearts):**
   * Saka memiliki total **5 Hati (Chrono-Hearts / Health Nodes)** di pojok kiri atas layar.
   * **Damage Serangan Musuh:**
     * Serangan monster biasa / cakar bayangan = **-1 Hati**.
     * Serangan proyektil berat / gelombang kejut bos = **-2 Hati**.
     * Terjatuh ke plasma reaktor / jurang asam = **Instan Death / Respawn Checkpoint**.
2. **Kapasitas & Aturan Medkit (Healing Pickup):**
   * **Kapasitas Maksimal:** **3 Slot Medkit** (tidak membutuhkan menu inventory terpisah).
   * **Efektivitas Healing:** **1 Medkit = Memulihkan 1 Hati (+1 Heart)** seketika saat menekan tombol `[H]` atau `[1]`.
   * **Sumber Perolehan Medkit di Tiap Era:**
     * *Era 2150:* Menemukan **`[Stimpack Medis 2150]`** di kotak P3K dinding atau meja lab Kakek.
     * *Era Abad 14 & 15:* Memetik **`[Rimpang Herbal Purba]`** di dekat mata air curug atau celah batu altar kuno.
     * *Stealth Reward:* Musuh yang dieksekusi menggunakan *Radial Stealth Takedown 1-Hit `[E]`* memiliki peluang menjatuhkan serpihan pendar kronal yang otomatis memulihkan 1 Hati.

---

## 09 — SISTEM LEVEL PROGRESI CHRONOS-BELT (STORY-DRIVEN UPGRADE)

| Level Sabuk | Terbuka di | Karakteristik Visual Sabuk (Arif) | Kemampuan & Mekanik Baru (Marvin & Falent) |
| :--- | :--- | :--- | :--- |
| **LEVEL 1** *(Prototype)* | **Prolog & Act 1** | Indikator LED berkedip **Hijau**. Sabuk masih berupa rakitan prototype dasar dengan kabel terbuka. | • **Time-Switch Dasar `[Q]`** (Lompat 2150 ↔ Abad ke-7 Sriwijaya).<br>• **Sinkronisasi Pemindai `[F]`** (*Arkeo-Optics*). |
| **LEVEL 2** *(Attuned)* | **Act 2** (Padjadjaran & Majapahit) | LED menyala **Biru Cyan** stabil. Terpasang soket batu api *Pasupati* dan konverter energi *Kunta*. | • **Konversi Senjata:** Mengubah energi kronal menjadi proyektil *Kunta* `[K]`.<br>• **Stabilisasi Gravitasi:** Mampu berjalan di zona *Anti-Gravitasi* Majapahit. |
| **LEVEL 3** *(Resonant)* | **Act 3** (Mataram & Sanctum) | LED menyala **Emas-Ungu**. Memancarkan cincin partikel berputar (*Cakra*) di kepala sabuk. | • **Detektor Kala Influence (%):** Membaca dan menguras energi altar sekte Kala.<br>• **Temporal Sever Mode:** Mengalirkan daya pemotong benang waktu ke *Cakra Basunanda*. |
| **LEVEL 4** *(Singularity / Max)* | **Final Act & Epilog** | LED menyala **Putih Prisma Penuh**. Sabuk terintegrasi sempurna dengan lensa mata Saka. | • **Medan Insulasi Kuantum (*Quantum Shield*):** Melindungi eksistensi Saka dari penghapusan semesta saat *Time Reset* memulihkan garis waktu. |

---

## 10 — USER INTERFACE & PEMETAAN TOMBOL ENGINE (GODOT 4)

* `A` / `D` : Gerak Horizontal (Kiri / Kanan)
* `Shift` *(Hold)* : Lari Cepat (*Sprint*)
* `Space` : Melompat (*Jump*) / **Keluar dari Cover (Semak/Kolong Peti/Terpal)** / Konfirmasi Dialog
* `C` / `Ctrl` : Meluncur (*Slide*) di bawah puing/pipa / Merunduk (*Crouch*)
* `E` : Interaksi Dasar (Single Tap) / **Masuk Cover (Semak/Kolong Peti/Terpal)** / **Sweet Spot QTE Detak Jantung** / **Stealth Takedown 1-Hit** / Dobrak Pintu Macet (Rapid Tap Mashing) / Investigasi & Putar Katup (Hold 2-3s)
* `F` / `Klik Tengah` : Pemindai Mata Bionik (*Arkeo-Optics Scanner*)
* `Q` / `Tab` : Time-Switch (Hanya aktif di zona *Historical Anchor*)
* `H` / `1` : **Gunakan Medkit / Stimpack / Herbal (+1 Hati)**
* `M` : **Buka Peta Lontar Kuno Sriwijaya** (Aktif jika memiliki item `[Peta Lontar Tua]`)
* `J` / `Klik Kiri` : Serangan Melee (Keris Pasupati di Act 1) / **Alternatif Input Sweet Spot QTE Detak Jantung**
* `K` / `Klik Kanan` : Serangan Jarak Jauh / Proyektil Kunta (Terbuka di Act 2)

---

## 11 — STRATEGI VERTICAL SLICE (TARGET TUGAS KULIAH ITERA)

1. **Playable Vertical Slice Demo:**
   * **Scope:** Prolog Lengkap + Act 1 Pesisir Sriwijaya (Durasi: ~25-30 Menit Playtime).
   * **Fitur Utama yang Ditampilkan:** Pengenalan Tara ➔ Tragedi Jembatan Pose Maestro ➔ Dialogue Branching 1, 2, 3 ➔ Penyamaran Jarik ➔ Stealth Cover & QTE Detak Jantung ➔ Navigasi Terowongan 3 Simpang Peta Lontar [M] ➔ Eureka Time-Switch ➔ Puzzle Bendungan Kausalitas ➔ Pertemuan Maran ➔ Boss Escape & Unlocking Keris Pasupati.
2. **Penutup Demo Praktikum:**
   * Layar sinematik: *"To Be Continued in Kala: Singkap Garis Waktu — Act 2 to Final"* dengan siluet 5 Tahap Tara, Maran, dan 3 Pusaka berikutnya.

---
*Dokumen kerja produksi v0.2. Aturan demo menjadi baseline pengujian; backlog cerita tetap dapat direvisi.*

**Versi pengumpulan UTS:** [GDD_UTS.md](GDD_UTS.md), mengikuti 11 bagian template ITERA. PDF pengumpulan berada di `output/uts/KALA_GDD_UTS.pdf`. Arah visual diselaraskan menjadi 2D pixel art pada 10 Oktober 2026.
