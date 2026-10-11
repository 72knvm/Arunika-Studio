# SPESIFIKASI & DAFTAR INVENTARIS ASET: VERTICAL SLICE (PROLOG & ACT 1)

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


## 0. PIPELINE PRODUKSI ASET v0.2

### Scope, gaya, dan sumber aset

- **P0:** aset minimum ruangan uji bendungan dua era; gunakan placeholder dahulu.
- **P1:** aset Prolog + Act 1 yang telah disetujui layout-nya.
- **P2:** Act 2–Epilog; inventarisnya disimpan sebagai backlog dan tidak menghambat demo.
- Arah visual adalah 2D pixel art, sesuai keputusan 10 Oktober 2026. Saka/Tara, prop, background, portrait, dan UI memakai detail pixel, proporsi, serta siluet yang konsisten. Sampling nearest menjaga tepi sprite tetap tajam. Moodboard: Tales of the Neon Sea, A Space for the Unbound, dan atmosfer teknologi Cyberpunk 2077 yang diterjemahkan ke 2D.
- Keputusan animasi dibuat di M0: cutout rig memerlukan bagian tubuh terpisah dan area sambungan; frame-by-frame memerlukan grid/frame/pivot konsisten. Jangan meminta satu gambar utuh lalu menganggapnya rig siap animasi.
- Buat satu paket referensi (Saka samping, Sriwijaya, 2150, katup, portrait, UI) dan uji dalam Godot sebelum produksi banyak gambar.

### Spesifikasi brief dan ekspor

| Field brief | Isi wajib |
| :--- | :--- |
| ID dan scope | Nama aset, ID scene, P0/P1/P2, fungsi gameplay |
| Referensi | Gambar acuan yang dipilih, palet era, ciri karakter, arah cahaya |
| Geometri | Ukuran canvas dan objek dalam piksel, perspektif samping, baseline lantai, titik tumpu dan skala terhadap Saka |
| Ekspor | PNG RGBA untuk transparansi; ukuran akhir dicek setelah ekspor, bukan hanya berdasarkan prompt |
| Layer/varian | Posisi tiap layer, area transparan, versi terbuka/tertutup, kebutuhan seamless bila benar-benar looping |
| Animasi | Metode, daftar state, jumlah frame/FPS atau daftar bagian rig; ditentukan sebelum produksi |
| Uji | Keterbacaan pada ukuran viewport, alpha tepi, alignment, collision, animasi dan konsistensi |

Viewport kerja awal disarankan 1920×1080; 2560×1440 merupakan opsi sumber gambar, bukan kewajiban semua aset. Ukuran final viewport dan pemain diputuskan M0. Ukuran gambar prop mengikuti kebutuhan layar, bukan otomatis Full HD.

Titik tumpu disimpan sebagai penempatan/offset atau metadata di proyek; file PNG tidak dianggap menyimpan pivot Godot. Collision dibuat dan diuji terpisah dari gambar. Layer background yang terlihat seperti lantai tidak otomatis mempunyai collision.

### Penamaan, parallax, dan pemisahan pekerjaan

- Gunakan lowercase snake_case. Background: `bg_[lokasi_atau_scene]_[isi]_t[n].png`; karakter: `char_[nama]_[outfit]_[state].png`; prop: `prop_[nama]_[state].png`; UI: `ui_[nama].png`.
- Tier `t0` paling jauh; tier berikutnya makin dekat. Nilai Z dan parallax di inventaris adalah titik awal visual, diuji sesuai kamera/versi engine; angka tier tidak wajib sama dengan nilai Z.
- Background berlapis harus memakai komposisi dan titik acuan yang sama. Jangan membuat tiap layer dengan horizon berbeda. Seamless hanya untuk layer yang memang diulang.
- Illustrator memproduksi pixel art final: sprite, portrait, prop, background, dan ornamen UI. Sumber serta hak penggunaan dicatat. Aset generasi AI yang saat ini dipakai dalam percobaan Godot merupakan placeholder dan tidak diperlakukan sebagai artwork final untuk tugas. Tracing hasil AI belum dianggap otomatis memenuhi larangan konten kreatif AI.
- Codex/Godot: tombol keypad fungsional, teks dialog, countdown, progress bar, collision, `.tscn`, `.gdshader`, dan partikel. Gambar UI adalah skin/dekorasi; teks dan angka dinamis tidak dibakar ke gambar.
- Audio memakai file yang tersedia dari tim/sumber yang disetujui. Pembuatan ilustrasi tidak berarti BGM/SFX juga telah dibuat. Catat sumber dan izin penggunaan dalam tracker aset.

### Siklus status dan kriteria siap

Brief → Gambar/sumber → Review → Ekspor → Integrasi → Playtest → Teruji. Kategori dalam matriks lama belum membuktikan file tersedia; jumlahnya estimasi, perlu dihitung kembali dari tracker.

Sebuah aset siap jika nama dan ukuran benar, alpha bersih, bentuk sesuai referensi, skala/pivot cocok, tidak menutupi petunjuk gameplay, dan sudah diuji dalam scene tujuan. Untuk parallax, cek overlap serta tepi layer saat kamera bergerak; untuk animasi, cek alignment frame dan state transisi.

### ID scene dan perubahan nama lama

Prolog memakai `pro_01`–`pro_05`; Act 1 memakai `act1_01`–`act1_05`, sesuai urutan pada STORY_FINAL.md. `proto_dam` adalah ruangan uji, bukan scene cerita tambahan. Pada nama file background, token `prolog_01` adalah alias lokasi untuk ID scene `pro_01`.

Nama layer lama berikut diselaraskan di inventaris. Ini adalah perubahan referensi dokumen, bukan bukti file aset telah diganti nama.

| Referensi lama | Nama produksi |
| :--- | :--- |
| `layer_0_skyline_astanapura.png` | `bg_prolog_01_skyline_t0.png` |
| `layer_1_rusun_room_shell.png` | `bg_prolog_01_room_shell_t1.png` |
| `layer_2_foreground_cables.png` | `bg_prolog_01_foreground_cables_t2.png` |
| `layer_0_bg_skyline.png` | `bg_prolog_02_skyline_t0.png` |
| `layer_1_water_maglev.png` | `bg_prolog_02_water_maglev_t1.png` |
| `layer_2_bridge_runway.png` | `bg_prolog_02_bridge_runway_t2.png` |
| `layer_3_foreground_poles.png` | `bg_prolog_02_foreground_poles_t3.png` |

---
# KALA: SINGKAP GARIS WAKTU
**Arunika Studio — Dokumentasi Pipeline Aset 2D, Audio SFX, & Panduan Engine Godot 4**  
*Target Tim:*  
1. **Marvin Karyanda** (123140185) — *Game Designer, Programmer, Tester*  
2. **Muhamad Arif Ardani** (123140186) — *Illustrator, Sound Engineer, Tester*  
3. **Falent Antonius Panjaitan** (123140124) — *Sound Engineer, Programmer, Tester*  
*Mata Kuliah:* Pengembangan Game (Teknik Informatika ITERA)  
*Target Engine:* Godot Engine 4.x (2D Pixel Art Narrative Puzzle-Platformer)

---

## 1. PANDUAN TIPE LATAR (2D BACKGROUND PIPELINE)

Dalam pengembangan game 2D pixel art, latar dapat memakai tilemap, gambar modular, serta parallax. Pemilihan metode mengikuti kebutuhan level dan konsistensi ukuran/detail pixel.

### Perbandingan Tipe Latar 2D:

| Tipe Latar | Karakteristik | Kelebihan | Kekurangan | Rekomendasi untuk Game Kita |
| :--- | :--- | :--- | :--- | :--- |
| **A. Grid Tilemap** | Tile pixel art berulang dengan ukuran grid yang konsisten. | Efisien untuk lantai, collision, dan variasi level. | Perlu variasi tile/prop agar pola pengulangan tidak terlalu terlihat. | Dapat dipakai pada bagian level yang membutuhkan modularitas. Ukuran tile ditetapkan berdasarkan skala gameplay. |
| **B. Single Huge Panoramic Plane** | 1 gambar raksasa utuh (misal 10000x1080 px). | Sangat artistik tanpa repetisi. | Boros VRAM memori, tidak ada kedalaman 3D/parallax. | ❌ **TIDAK EFISIEN** |
| **C. Multi-Layer Modular Parallax & Prop Decals (TALES OF THE NEON SEA / HOLLOW KNIGHT STYLE)** | Membagi pemandangan menjadi **4–5 Layer Terpisah** dengan kecepatan scroll berbeda + Prop/Decal modular. | ✅ **Kedalaman sinematik luar biasa**<br>✅ **Bisa looping tak terbatas**<br>✅ **Hemat memori & dinamis**<br>✅ **Interaksi fisika presisi** | Memerlukan pemisahan layer rapi dari ilustrator. | ⭐ **STANDAR EMAS (PILIHAN KITA)** |

---

## 2. STANDAR TEKNIS ASET ILUSTRASI (PANDUAN UNTUK ARIF)

1. **Format File:** `PNG RGBA (8-bit per kanal; alpha transparan)` dengan transparansi penuh (*Alpha Channel*).
2. **Resolusi Target Dasar:** Canvas `1920x1080` (Full HD) atau `2560x1440` (2K) untuk background luas.
3. **Standar Naming Convention (Struktur Folder Proyek Godot):**
   * Background Layer: `res://assets/sprites/backgrounds/bg_[lokasi]_[layer_name]_[tier].png` (Contoh: `bg_bridge_skyline_t0.png`)
   * Karakter Cutout / Sprite: `res://assets/sprites/characters/char_[nama]_[pose/outfit].png` (Contoh: `char_saka_jarik_idle.png`)
   * Prop Interaktif: `res://assets/sprites/props/prop_[nama]_[state].png` (Contoh: `prop_safe_closed.png`)
   * UI & Icon: `res://assets/sprites/ui/ui_[nama].png` (Contoh: `ui_keypad_4digit.png`)
   * Shader: `res://assets/shaders/[nama].gdshader`
   * Audio SFX: `res://assets/audio/sfx/sfx_[nama].wav` / `ogg`
4. **Pivot Point (Titik Tumpu di Godot):**
   * Karakter & Prop Berdiri: *Bottom Center* (Tengah Bawah).
   * Platform Puing Melayang: *Center* (Tengah).
   * UI & Textbox: *Top Left* atau *Center*.
5. **Color Palette & Lighting Guidelines:**
   * *Astanapura 2150 — Prolog pagi:* Langit dan cahaya memakai oranye hangat (`#f97316`) serta emas pucat (`#fde68a`). Bangunan, air, dan interior memakai biru gelap/navy (`#0f172a`) serta abu baja (`#334155`); cyan (`#06b6d4`) menjadi aksen lampu, layar, dan perangkat. Kamar lebih redup dengan cahaya hangat dari jendela; jembatan dan kedai lebih terang serta hangat. Magenta bukan warna dominan Prolog. Palet ini adalah acuan produksi, bukan hasil pengukuran persis warna pada placeholder.
   * *Reruntuhan 2150 di Act 1:* Abu baja (`#334155`), cokelat karat (`#78350f`), kuning-hijau belerang (`#a3a33a`), dan abu kabut (`#64748b`). Tahun yang sama tidak berarti semua lokasi memakai palet kota Astanapura.
   * *Wanua Sriwijaya 682 M (Act 1):* Pasir Emas (`#fde047`), Hijau Hutan Tropis (`#15803d`), Cokelat Kayu Ulin (`#78350f`), Biru Laut Pesisir (`#0284c7`).
   * *Tragedi Prolog dan aura Sang Hyang Kala:* Ungu kosmik (`#581c87`, `#9333ea`) dan hitam singularitas (`#000000`) mengganggu suasana pagi melalui portal, retakan, serta pengaruh pada Tara. Emas Pasupati (`#fbbf24`) adalah aksen pusaka terpisah.

---

## 3. STRUKTUR POHON INVENTARIS ASET VERTICAL SLICE

```
VERTICAL SLICE ASSET MASTER TREE
├── BAGIAN I: PROLOG — "Ketika Dewa Turun" (Astanapura 2150)
│   ├── SCENE 1: Unit Rusunawa Saka (Kamar Tidur Pagi)
│   ├── SCENE 2: Skybridge Astanapura & Kedai Mak Inah
│   ├── SCENE 3: Langit Robek & Tragedi Jembatan (Pose Maestro)
│   ├── SCENE 4: Lorong Sektor Bawah & Dobrak Pintu Rusunawa
│   └── SCENE 5: Sudut Stash Bengkel & Brankas Chronos-Belt
│
└── BAGIAN II: ACT 1 — "Jejak yang Tertinggal" (Wanua Sriwijaya 682 M & Reruntuhan 2150)
    ├── SCENE 1: Pesisir Wanua Sriwijaya, Galangan Ki Pranata, & Jarik
    ├── SCENE 2: Pos Penjagaan, Tutorial Stealth Stage 1, & Eureka Time-Switch [Q]
    ├── SCENE 3: Pergudangan Rempah, Peta Lontar [M], & Puzzle Kausalitas Bendungan
    ├── SCENE 4: Lembah Danau Asam yang Mengering & Pertemuan MARAN
    └── SCENE 5: Ruang Altar Kuil Kuno & Kebangkitan Keris Pasupati (Klimaks)
```

---

<div class="page-break"></div>

# BAGIAN I: DAFTAR INVENTARIS ASET PROLOG

### **[pro_01 / P1] SCENE 1: Unit Rusunawa Saka (Kamar Tidur Pagi)**

#### 1. Background Modular Parallax (3 Layer)
* `bg_prolog_01_skyline_t0.png` *(Z: -30, Parallax: 0.1x)* : Siluet megastruktur Astanapura 2150 saat fajar, rel maglev melintas di kejauhan, cahaya oranye menembus kabut smog.
* `bg_prolog_01_room_shell_t1.png` *(Z: 0, Parallax: 1.0x)* : Dinding baja modular rusunawa dengan jendela horizontal memanjang di sisi kiri-tengah (transparan memperlihatkan Layer 0), kisi ventilasi uap, dan lantai pelat baja dengan karpet usang (+ StaticBody2D Collision).
* `bg_prolog_01_foreground_cables_t2.png` *(Z: 20, Parallax: 1.3x)* : Kabel tebal melintang di plafon depan, pipa hidrolik atas, dan partikel debu halus fajar untuk memberi ilusi kedalaman 3D saat kamera bergerak.

#### 2. Props & Interaktif (Tersusun dari Kiri ke Kanan)
* `prop_kasur_saka.png` : Kasur busa lantai / dipan rendah futuristik tempat Saka tidur dan bangun di ujung kiri kamar.
* `prop_alarm_digital.png` : Jam alarm digital hologram melayang di samping kasur (SFX alarm bip-bip).
* `prop_terminal_pc_meja.png` : Meja komputer terminal kerja Saka di tengah (layar monitor & keyboard kerja Saka).
* `prop_stash_nook_partition.png` : Bilik partisi pintu baja khusus Stash Bengkel pribadi Saka (ala V CP2077) berisi meja solder rakitan kabel, rak perkakas, dan brankas baja Kakek di kolong meja.
* `prop_pintu_keluar_rusun.png` : Pintu geser hidrolik baja unit rusunawa di ujung kanan dengan lampu LED indikator hijau (Trigger `[E]` untuk keluar ke lorong bersama Tara).

#### 3. Karakter & Portrait UI
* **Saka Rig (`char_saka_casual`):** Desain dari Arif (Animasi: `Sleep_Wakeup`, `Idle_Ngantuk`, `Walk_Right`).
* **Tara Rig (`char_tara_casual`):** Desain dari Arif (Animasi: `Idle_Smile`, `Walk`, `Hands_On_Hips`).
* **Portrait UI:** Desain dari Arif (`Saka_Ngantuk`, `Saka_Hangat`, `Adik_Cemberut`, `Adik_Ceria`).

---

### **[pro_02 / P1] SCENE 2: Skybridge Astanapura & Kedai Sarapan Mak Inah**

#### 1. Background Modular Parallax (4 Tier)
* `bg_prolog_02_skyline_t0.png` *(Z: -30, Parallax: 0.1x)* : Siluet megastruktur Astanapura, kabut tipis fajar, sinar matahari oranye. *(Looping Seamless)*.
* `bg_prolog_02_water_maglev_t1.png` *(Z: -20, Parallax: 0.3x)* : Permukaan air selat kota yang memantulkan cahaya + tiang rel maglev layang dengan kereta melintas.
* `bg_prolog_02_bridge_runway_t2.png` *(Z: 0, Parallax: 1.0x)* : Jalur jembatan pejalan kaki berpagar kaca transparan tempat Saka dan Tara berjalan (+ Collision Runway).
* `bg_prolog_02_foreground_poles_t3.png` *(Z: 20, Parallax: 1.4x)* : Tiang lampu jembatan, kabel optik melintang atas, efek blur fajar di depan kamera.

#### 2. Set Piece: Kedai Sarapan Mak Inah (Ujung Jembatan)
* `prop_kedai_mak_inah.png` : Gerobak kedai kayu vintage beratap terpal oranye dengan panci tembaga kari.
* `prop_meja_kayu_set.png` : Meja kayu dan bangku panjang teras menghadap selat.
* `prop_mangkuk_lontong_kari.png` : Mangkuk lontong kari kuning keemasan dengan telur belah dua, tahu, dan kerupuk aci merah.
* `vfx_steam_kari.tscn` : Partikel uap panas mengepul dari mangkuk kari (`GPUParticles2D`).
* `prop_gelas_es_teh.png` : Gelas es teh tawar dingin berembun.

#### 3. Karakter & UI
* **Saka & Tara (sprite 2D pixel art dengan proporsi gameplay konsisten):** Animasi jalan berdampingan (`Walk_Together`), animasi duduk di meja (`Sit_Eat`).
* **Branch 1 UI:** Textbox pilihan respons dialog ganda (Pilihan A: Protektif vs Pilihan B: Jujur).

---

### **[pro_03 / P1] SCENE 3: Langit Robek & Tragedi Jembatan (Pose Maestro)**

#### 1. Environment Rusak & Rintangan Platforming
* `bg_bridge_sky_storm.png` : Langit mendadak berubah menjadi pusaran ungu kosmik pekat berpetir.
* `prop_billboard_fallen.png` : Tiang papan reklame holo raksasa yang ambruk melintang (Rintangan **Slide `Ctrl`**).
* `prop_bridge_chasm.png` : Retakan aspal jembatan yang amblas terbuka (Rintangan **Jump `Space`**).
* `prop_floating_slab_1.png` s/d `prop_floating_slab_4.png` : 4 variasi lempengan aspal & beton jembatan melayang anti-gravitasi (+ OneWay Collision untuk platform jumping Saka).

#### 2. Visual Karakter & Rigging Puncak
* **Tara Pose Maestro:**
  * Model Tara melayang 10 meter di udara, rambut berkibar ke atas melawan gravitasi.
  * **Pose Maestro:** Kedua tangan terentang lebar ke samping.
  * Mata ungu bercahaya (`Emission Glow`).
  * Shader retakan hitam menyala di sekujur kulit (`Temporal_Fracture.gdshader`).
* **Saka Action Rig:**
  * Animasi Sprint (`Shift`), Slide (`Ctrl`), Jump (`Space`), Reaching Out Hand (`Rescue_Reach`), Blast Knockback (`Blown_Away`).

#### 3. Prop Kunci & VFX Spektakuler
* `prop_liontin_tara_drop.png` : Liontin logam pemberian Saka yang terputus dari leher Tara dan tergeletak berdenting di aspal (+ pendar cyan).
* `vfx_time_rift_portal.tscn` : Pusaran portal hitam-ungu singularitas raksasa di belakang Tara.
* `vfx_zero_gravity_debris.tscn` : Serpihan kaca, baut, dan aspal yang mengorbit melingkari tubuh Tara.
* `vfx_impact_flash.tscn` : Kilatan putih total 0.3 detik saat Kala bermanifestasi.

---

### **[pro_04 / P1] SCENE 4: Lorong Sektor 4 & Dobrak Pintu Rusunawa**

#### 1. Environment & Pintu Macet
* `bg_corridor_sector4.png` : Lorong rusunawa berasap, lampu darurat putar warna merah berkedip.
* `prop_lockdown_door_closed.png` : Pintu geser baja hidrolik terkunci rapat dengan lampu indikator merah menyala.
* `prop_lockdown_door_broken.png` : Pintu baja yang sudah jebol/terbuka paksa setelah di-mash.

#### 2. UI Interaktif
* `ui_rapid_tap_prompt.png` : Indikator visual tombol `[E]` berdenyut cepat.
* `ui_mash_progress_bar.png` : Bar progres dorongan manual (0% ➔ 50% Dialog ➔ 100% Jebol).

---

### **[pro_05 / P1] SCENE 5: Sudut Stash Bengkel & Brankas Chronos-Belt (60s Countdown)**

#### 1. Environment Sudut Stash (Cyberpunk Style)
* `bg_room_apartment.png` : Ruang tengah apartemen yang berantakan karena getaran gempa.
* `bg_stash_nook_partition.png` : Sudut partisi kawat baja khusus (Stash Bengkel pribadi Saka) berisi rak suku cadang dan perkakas kakek.
* `prop_workbench_pc.png` : Terminal komputer meja kerja dengan layar berkedip memo kakek.

#### 2. Puzzle Brankas & Chronos-Belt
* `ui_keypad_modal.png` : UI Pop-up Keypad Angka Digital 4-Digit (Layar PIN, tombol angka `0-9`, Enter, Clear).
* `prop_safe_closed.png` : Brankas hidrolik baja berat tertanam di bawah meja kerja.
* `prop_safe_opened.png` : Brankas terbuka mengeluarkan uap nitrogen dingin (`vfx_nitrogen_steam.tscn`).
* `prop_chronos_belt_pedestal.png` : **Chronos-Belt (Level 1 Prototype)** di atas bantalan magnetik bercahaya cyan dengan roda gigi jarum detik berdetik.
* `prop_chronos_belt_equipped.png` : Sprite sabuk saat sudah terpasang di pinggang Saka.

#### 3. HUD & Timer
* `ui_hud_countdown_60s.png` : Timer countdown digital merah berkedip di pojok atas HUD (`00:59`... `00:00`).
* `vfx_chronos_warp_leap.tscn` : Ledakan partikel prisma kronal saat Saka menarik tuas sabuk menuju tahun 682 Masehi.

---

<div class="page-break"></div>

# BAGIAN II: DAFTAR INVENTARIS ASET ACT 1 (WANUA SRIWIJAYA 682 M & RERUNTUHAN 2150)

### **[act1_01 / P1] SCENE 1: Pesisir Wanua Sriwijaya, Galangan Ki Pranata, & Penyamaran Jarik**

#### 1. Background Modular Parallax Pantai (4 Tier)
* `bg_sriwijaya_sky_t0.png` *(Z: -40, Parallax: 0.05x)* : Langit biru cerah tropis abad ke-7, awan gumpalan putih lembut, matahari pagi pesisir Sumatra.
* `bg_sriwijaya_sea_islands_t1.png` *(Z: -30, Parallax: 0.2x)* : Lautan biru Selat Malaka yang berkilauan, siluet pulau seberang, kapal layar cadik Sriwijaya melintas pelan.
* `bg_sriwijaya_village_platforms_t2.png` *(Z: 0, Parallax: 1.0x)* : Garis pantai pasir putih, bebatuan karang berlumut, rumah panggung kayu ulin bertiang tinggi di atas air (+ StaticBody2D Collision).
* `bg_sriwijaya_foreground_foliage_t3.png` *(Z: 20, Parallax: 1.3x)* : Pelepah daun pohon kelapa melengkung di tepi layar, rumpun ilalang pantai dengan efek hembusan angin.

#### 2. Set Pieces & Props Desa Pesisir
* `prop_pondok_galangan.png` : Bangsal kerja galangan perahu Ki Pranata berbahan kayu ulin dan atap daun rumbia.
* `prop_perahu_cadik_halfbuilt.png` : Kerangka lambung perahu layar cadik kayu ulin setengah jadi dengan pasak kayu tertancap.
* `prop_perkakas_ki_pranata.png` : Pahat besi purba, kapak beliung batu, palu kayu, dan tatal serutan kayu berserakan di tanah.
* `prop_jaring_ikan_jemur.png` : Jala anyaman ijuk yang digantung pada tiang bambu.
* `prop_tempayan_air.png` : Tempayan gerabah tanah liat kuno tempat penampungan air tawar.
* `prop_jarik_sriwijaya_pickup.png` : Kain jarik tenun khas Sriwijaya bermotif geometris pesisir yang terlipat rapi di bangku kayu (+ pendar interaktif `E`).

#### 3. Karakter & Potret UI
* **Saka Jarik Rig (`char_saka_jarik`):** Saka bertelanjang dada mengenakan balutan kain jarik tenun Sriwijaya dengan sabuk Chronos-Belt terpasang kokoh di pinggangnya (Animasi: `Wakeup_Beach`, `Idle_Confused`, `Walk`, `Inspect_Belt`).
* **Ki Pranata (`char_ki_pranata`):** Kakek tua berotot liat, bertelanjang dada, memakai udeng tenun pesisir, memegang pahat kayu (Animasi: `Chisel_Wood`, `Talk_Warm`, `Warn_Gesture`).
* **NPC Nelayan & Warga:** Nelayan memikul hasil tangkapan, anak pesisir berlari.
* **Portrait UI:** `Saka_Jarik_Santai`, `KiPranata_Ramah`, `KiPranata_Peringatan`, `KiPranata_Heran`.
* **Branch 2 UI Modal:** Textbox pilihan respons Ki Pranata (Pilihan A: Bohong/Sombong vs Pilihan B: Sopan/Minta Tolong).

---

### **[act1_02 / P1] SCENE 2: Pos Penjagaan, Tutorial Stealth Stage 1, & Eureka Time-Switch [Q]**

#### 1. Environment Pos Jaga & Gerbang Kayu Ulin
* `bg_guardpost_palisade.png` : Dinding pagar kayu pancang ulin setinggi 4 meter mengelilingi pos penjagaan militer Sriwijaya.
* `bg_guardpost_watchtower.png` : Menara pantau bertingkat kayu ulin dengan obor minyak dan bendera panji kerajaan merah-keemasan berkibar.
* `prop_gerbang_ulin_locked.png` : Gerbang ganda balok kayu ulin raksasa terkunci palang baja dan rantai gembok purba (Rintangan Utama).
* `prop_cover_bush.png` : Rumpun semak ilalang lebat setinggi dada manusia tempat Saka bersembunyi (Trigger Masuk `[E]` / Keluar `[Space]`).

#### 2. Prajurit Patroli & AI Vision Cone
* **Prajurit Sriwijaya (`char_guard_sriwijaya`):** Prajurit bertubuh tegap, mengenakan rompi zirah kulit bertatah perunggu, celana kain tenun lilit, udeng tembaga, dan tombak bermata ganda (Animasi: `Patrol_Walk`, `Stop_Inspect_Suspicious`, `Alert_Turn`, `Spear_Thrust_Attack`).
* **Vision Cone Dynamic Mesh:**
  * *Hijau:* Patroli normal (Jangkauan pandang 8 meter, kecepatan jalan stabil).
  * *Kuning:* Mencurigai goyangan semak (Berhenti 3 detik tepat di depan semak, memicu QTE Detak Jantung).
  * *Merah:* Deteksi penuh (Tanda seru `!`, membunyikan trompet tanduk, mengejar instan).

#### 3. HUD Stealth & Mini-Game Detak Jantung
* `ui_stealth_hiding_hud.png` : Indikator siluet mata tertutup di pojok kiri atas saat Saka berada di dalam cover.
* `shader_hiding_silhouette.gdshader` : Shader transparansi (Alpha 50% + Modulate Tint Biru Gelap) yang diaplikasikan ke sprite Saka saat bersembunyi.
* `ui_heartbeat_qte_bar.png` : Bar horizontal transparan dengan zona target hijau (*Sweet Spot*) dan jarum osilasi merah bolak-balik (Prompt Input: `[Klik Kiri]` / `[E]`).
* `ui_time_switch_anchor_prompt.png` : Ikon sabuk berkedip cyan dengan prompt `[Q] TIME-SWITCH ACTIVE` saat berada di titik Historical Anchor.
* `ui_time_switch_jammed_led.png` : Indikator LED kuning-merah sabuk saat tombol `[Q]` ditekan di luar zona resonansi.

---

### **[act1_03 / P1] SCENE 3: Pergudangan Rempah, Peta Lontar [M], & Puzzle Kausalitas Bendungan**

#### 1. Area Pergudangan & Objek Persembunyian Indoor
* `bg_warehouse_spices_interior.png` : Aula gudang kayu luas berdinding papan ulin dengan berkas cahaya matahari menembus celah atap rumbia.
* `prop_cover_spice_crates.png` : Tumpukan peti balok kayu manis dengan kolong bawah terbuka tempat Saka merunduk sembunyi (`[E]`).
* `prop_cover_tarp_pepper.png` : Terpal kain goni tebal penutup gundukan karung lada hitam tempat Saka menyelinap di baliknya (`[E]`).

#### 2. Terowongan Drainase Bawah Tanah & Peta Lontar [M]
* `bg_drainage_tunnel_wet.png` : Lorong saluran air bawah tanah berdinding batu bata kuno berlumut dengan air setinggi mata kaki (+ pantulan riak air).
* `prop_tunnel_grate_iron.png` : Kisi-kisi besi saluran air berkarat yang bisa dibuka menggunakan kunci/tuas.
* `item_peta_lontar_tua.png` : Item daun lontar tua bertuliskan aksara Pallawa dan denah sketsa tinta 3 persimpangan terowongan.
* `ui_lontar_map_modal.png` : UI Pop-up Peta Lontar (Denah sketsa saluran air dengan tanda panah rute benar: *Kanan ➔ Kiri ➔ Kanan*).

#### 3. Menara Bendungan Air Tradisional & Mekanik Kausalitas
* `bg_dam_monumental_sriwijaya.png` : Struktur bendungan air kayu ulin raksasa pembendung sungai purba dengan roda kincir air berputar.
* `prop_dam_sluice_gate_closed.png` : Pintu air kayu masif yang menahan debit aliran sungai purba.
* `prop_dam_crane_valve.png` : Katup roda kemudi kayu raksasa di puncak menara bendungan (Mekanik: Tahan `[Hold E]` 3 Detik untuk memutar katup).
* `vfx_dam_water_divert_burst.tscn` : Semburan air berdebit masif yang mengalir ke saluran pelimpah menuju laut lepas.
* `vfx_temporal_echo_ripple.tscn` : Efek distorsi layar gelombang kausalitas emas saat manipulasi masa lalu mengeringkan danau masa depan 2150.

---

### **[act1_04 / P1] SCENE 4: Lembah Danau Asam yang Mengering & Pertemuan MARAN (2150)**

#### 1. Environment Lembah Dasar Danau Asam 2150
* `bg_acid_lake_bed_dry.png` : Dasar danau asam yang surut mengering total, menampilkan kerak belerang kuning-kehijauan, tanah lumpur mengeras pecah-pecah, dan uap kimia berdesis.
* `prop_excavator_rusted_wreck.png` : Rangka bangkai ekskavator tambang raksasa 2150 yang keropos berkarat dimakan asam.
* `prop_industrial_pipe_broken.png` : Pipa saluran limbah industri berdiameter 2 meter yang terpotong melintang sebagai platform platforming.
* `vfx_acid_steam_vent.tscn` : Kepulan uap kimia belerang tipis keluar dari celah retakan tanah kering (`GPUParticles2D`).

#### 2. Karakter MARAN & Set Senjata
* **Maran Sprite Rig (`char_maran`):** Pria jangkung (186 cm, 29 tahun) berambut marun kemerahan acak-acakan, jaket taktis survivor usang dengan harness ransel modular, dan modul Arkeo-Scanner di lengan kiri.
* **Senapan Pipa Pengikis (`prop_maran_scraper_rifle.png`):** Senapan laras panjang rakitan dari pipa industri dengan tabung reaktor kinetik biru.
* **Animasi Maran:** `Aim_Rifle_Threaten`, `Fire_Recoil`, `Holster_Weapon`, `Toss_Stimpack`, `Leap_Background_Wall`.
* **Portrait UI:** `Maran_Waspada`, `Maran_Pahit`, `Maran_Netral`, `Maran_SenyumTipis`, `Maran_Kecewa`.
* **Item Reward:** `item_stimpack_medis_2150.png` : Tabung injektor medis taktis militer beriluminasi hijau (+1 stok medkit; kapasitas tetap 3).
* **Branch 3 UI Modal:** Textbox pilihan respons Saka (Pilihan A: Agresif / Ditembak -1 Hati saat ini vs Pilihan B: Fokus Tara / Dapat Stimpack).

---

### **[act1_05 / P1] SCENE 5: Ruang Altar Kuil Kuno & Kebangkitan Keris Pasupati (Klimaks Act 1)**

#### 1. Environment Kuil Kuno & 3 Zona Arsitektur
* `bg_temple_foyer_entrance.png` *(Zona 1)* : Aula pintu masuk kuil megalitikum purba tertimbun puing beton 2150 (Tempat Gelombang 1 & Evasive Roll).
* `bg_temple_pillar_corridor_chasm.png` *(Zona 2)* : Koridor lantai ubin batu berbaris pilar dengan 3 celah jurang retak menganga beruap asam (Tempat Gelombang 2 Platforming & Mid-Air Monster Vault).
* `bg_temple_altar_sanctuary.png` *(Zona 3)* : Pelataran puncak punden berundak, prasasti batu kuno bercahaya emas, dan pusaran portal waktu raksasa berputar di dinding belakang.
* `bg_temple_balcony_background.png` *(Background Layer Z: -15)* : Balkon lantai 2 reruntuhan tempat Maran berdiri menembakkan senapan cover.

#### 2. Tiga Utusan Sang Hyang Kala (Monster Anomaly)
* **Utusan Kala 1 (`char_utusan_kala_crawler`):** Makhluk bayangan berkabut hitam merayap di langit-langit kubah kuil (Gelombang 1).
* **Utusan Kala 2 (`char_utusan_kala_flyer`):** Makhluk bayangan bersayap cakar tajam yang menyembul melompat dari celah jurang ke-3 (Gelombang 2).
* **Utusan Kala 3 (`char_utusan_kala_behemoth`):** Monster raksasa bertanduk hitam bercabang dengan mata ungu kosmik dan cakar bayangan masif (Gelombang 3).
* **Animasi Monster:** `Ceiling_Pounce`, `Chasm_Ambush_Rise`, `Midair_Stagger_Exposed`, `Behemoth_Ground_Smash`, `Behemoth_Swipe`, `Temporal_Dissolve_Death`.

#### 3. Pusaka Nusantara 1: KERIS PASUPATI
* `prop_keris_pasupati_in_stone.png` : Keris Pasupati tertancap di atas prasasti batu kuno, bilah luk berlekuk memancarkan bara api spiritual.
* `prop_keris_pasupati_held.png` : Bilah keris terselubung kobaran api spiritual keemasan murni di tangan Saka.
* **Saka Combat Rig (`char_saka_pasupati_combat`):**
  * `Pull_Keris_Hold` : Saka mencengkeram gagang keris dengan kedua tangan sambil dialiri cahaya emas.
  * `Pasupati_Ignite_Awakening` : Saka mengangkat keris tinggi saat bilahnya meledak dalam kobaran api suci.
  * `Melee_Slash_Combo_1` & `Melee_Slash_Combo_2` : Sabetan horizontal cepat berjejak api.
  * `Finisher_Flame_Cleave` : Lompatan tebasan vertikal membelah tubuh Utusan 3.
* **Portrait UI:** `Saka_Awakened_Pasupati`, `Saka_Napas_Terengah`, `Maran_Waspada`, `Maran_Netral`.

#### 4. UI QTE, HUD Tempur, & Layar Demo Clear
* `ui_qte_jump_prompt.png` : Indikator tombol `[Space]` (Evasive Roll & Mid-Air Trampoline Step).
* `ui_hold_e_pasupati_gauge.png` : Meteran melingkar emas saat menahan tombol `[E]` selama 3 detik untuk mencabut keris.
* `ui_action_prompt_strike_j.png` : Prompt berkedip `[TEKAN TOMBOL J / KLIK KIRI (TEBASAN PASUPATI)]`.
* `vfx_pasupati_fire_trail.tscn` : Jejak partikel api spiritual emas-oranye pada ayunan bilah keris (`GPUParticles2D`).
* `vfx_monster_death_burst.tscn` : Ledakan abu partikel singularitas kosmik saat Utusan 3 terbelah.
* `ui_vertical_slice_demo_clear.png` : Layar rekapitulasi Demo Clear Vertical Slice (*Status Ekspedisi Chronal & Teaser Rimba Padjadjaran Act 2*).

---

### **BACKLOG DI LUAR DEMO — BAGIAN II.B: DAFTAR ASET ACT 2 (PHASE 1: RIMBA PURBA PADJADJARAN)**

#### 1. Backgrounds & Environment Padjadjaran
* `bg_padjadjaran_curug_valley.png` : Lembah ngarai bawah air terjun raksasa, bebatuan kali berlumut, kanopi pohon paku purba.
* `bg_padjadjaran_misty_slope.png` : Lereng tebing berbatu cadas menanjak terjal dengan kabut tebal dan sulur akar gantung.
* `bg_padjadjaran_hunter_cabin_terrace.png` : Teras tebing dengan saung panggung kayu dan pohon beringin purba berakar gantung.
* `bg_geothermal_lab_2150_ruins.png` : Ruang fasilitas reaktor plasma dan lab riset Dr. Raden Wikana yang berdebu dengan monitor tabung kuno.

#### 2. Karakter & Set Pakaian Baru
* **Saka Rompi Pemburu Rig (`char_saka_rompi_padjadjaran`):** Saka mengenakan rompi tebal kulit kijang rimba di atas kain jarik tenun Sriwijaya dengan sabuk Chronos-Belt di pinggang (Animasi: `Climb_Vines`, `Air_Drop_Dive`, `Sneak_Walk`, `Melee_Pasupati_Combo`).
* **Sentinel Anomali Purba (`char_sentinel_anomali_purba`):** Makhluk bayangan berkabut ungu setinggi 2 meter dengan zirah kristal dada tebal, cakar runcing, dan inti fraktal di tengkuk belakang (Animasi: `Patrol_Walk`, `Inspect_Bush_Suspicious`, `Vaporize_Death_Silent`, `Alert_Turn_Slash`).
* **Portrait UI:** `Saka_Rompi_Pemburu`.

#### 3. Props Interaktif & Pickups
* `prop_rompi_pemburu_pickup.png` : Rompi kulit tebal pemburu Padjadjaran yang tergantung di dinding bambu saung (+ pendar interaktif `E`).
* `prop_saung_pemburu_ruined.png` : Saung panggung kayu dan bambu beratap ijuk yang rusak berantakan.
* `prop_pohon_beringin_vines.png` : Dahan pohon beringin purba melintang dengan akar gantung yang bisa dipanjat.
* `prop_lontar_kulit_kayu.png` : Lempeng kulit kayu bertuliskan aksara Sunda Kuno tertancap belati tembaga.
* `item_rimpang_herbal_purba.png` : Tanaman liar berumbi emas berpendar (Item medis pemulih 1 Hati).
* `item_stimpack_medis_2150.png` : Tabung injektor medis 2150 di lab Kakek (Item medis +1 stok medkit; memulihkan 1 Hati saat dipakai).

#### 4. UI QTE, Shaders, & Audio Tambahan
* `ui_radial_ring_360.png` : Lingkaran HUD emas dengan busur target Sweet Spot untuk Pasupati Silent Strike QTE.
* `ui_radial_needle.png` : Jarum penunjuk bercahaya yang berputar 720°/detik pada sumbu tengah.
* `sfx_hunter_vest_equip.wav` : Suara gesekan kulit tebal saat Saka mengenakan rompi pemburu.
* `sfx_air_drop_whoosh.wav` : Hembusan angin kencang saat Saka menukik loncat dari dahan pohon ke musuh.
* `sfx_stealth_vaporize.wav` : Desis lembut debu partikel saat musuh hancur senyap 1-hit kill.

---

<div class="page-break"></div>

# BAGIAN III: DAFTAR ASET AUDIO, SFX, & BGM LENGKAP

### A. Sound Effects (SFX) — Prolog & Act 1

| Kode File SFX | Deskripsi Audio | Penggunaan di Scene |
| :--- | :--- | :--- |
| `sfx_alarm_digital.wav` | Bunyi alarm jam digital rusunawa (*BIP-BIP-BIP*). | Prolog Scene 1 (Kamar) |
| `sfx_city_ambient_morning.ogg` | Angin fajar, suara debur selat jauh, dengung rel maglev. | Prolog Scene 2 (Skybridge) |
| `sfx_curry_slurp_burn.wav` | Gigitan kerupuk garing & desis kepanasan lidah Tara. | Prolog Scene 2 (Kedai Mak Inah) |
| `sfx_siren_sector_lockdown.ogg` | Sirine darurat Astanapura melolong (*WUUU-WUUU*). | Prolog Scene 3 & 4 |
| `sfx_quake_rumble.wav` | Gemuruh gempa tektonik berat & suara kaca jembatan retak. | Prolog Scene 3 (Awal Tragedi) |
| `sfx_zero_gravity_hum.ogg` | Suara dengung supernatural low-frequency gravitasi nol. | Prolog Scene 3 (Pose Maestro) |
| `sfx_kala_voice_reverb.wav` | Suara ganda kosmik menggelegar Sang Hyang Kala. | Prolog Scene 3 (Pose Maestro) |
| `sfx_pendant_clink_asphalt.wav` | Dentingan halus liontin Tara jatuh membentur aspal. | Prolog Scene 3 (Akhir Tragedi) |
| `sfx_door_mash_struggle.wav` | Suara gesekan logam tuas pintu saat di-mash cepat. | Prolog Scene 4 (Dobrak Pintu) |
| `sfx_door_burst_open.wav` | Suara engsel baja patah dan pintu terbanting terbuka. | Prolog Scene 4 (Pintu Jebol) |
| `sfx_keypad_beep.wav` | Bunyi tuts angka keypad digital (*Bip-Bip-Bip*). | Prolog Scene 5 (PIN 2408) |
| `sfx_safe_steam_release.wav` | Desis pelepasan hidrolik & uap nitrogen brankas. | Prolog Scene 5 (Brankas Terbuka) |
| `sfx_chronos_warp_explosion.wav` | Ledakan energi prisma kronal saat melompat antarzaman. | Prolog Scene 5 & Time-Switch |
| `sfx_beach_waves_seagull.ogg` | Debur ombak pantai pasir putih & suara burung camar. | Act 1 Scene 1 (Pantai Sriwijaya) |
| `sfx_wood_carving_hammer.wav` | Suara pahat dan palu kayu galangan perahu tradisional. | Act 1 Scene 1 (Ki Pranata) |
| `sfx_jarik_equip.wav` | Suara gesekan kain tenun saat Saka mengenakan jarik. | Act 1 Scene 1 (Pakai Jarik) |
| `sfx_bush_rustle.wav` | Gemerisik daun semak saat Saka masuk/keluar cover. | Act 1 Scene 2 (Stealth Semak) |
| `sfx_heartbeat_thump.wav` | Detak jantung mendentum kencang (*thump-thump*) & napas tertahan. | Act 1 Scene 2 (Danger Zone QTE) |
| `sfx_heartbeat_success.wav` | Helaan napas lega pelan & suara langkah prajurit menjauh. | Act 1 Scene 2 (QTE Sukses) |
| `sfx_guard_alert_horn.wav` | Tiupan trompet tanduk peringatan prajurit Sriwijaya (*HOOONK!*). | Act 1 Scene 2 (Stealth Gagal) |
| `sfx_time_switch_whoosh.wav` | Desingan distorsi kronal saat menekan `[Q]` Time-Switch. | Act 1 Scene 2 & 3 |
| `sfx_belt_gear_jam.wav` | Roda gigi sabuk macet (*BZZT-KLIK*) jika ditekan di luar zona. | Act 1 Scene 2 (Anti-Exploit Feedback) |
| `sfx_tunnel_water_drip.ogg` | Gema tetesan air dan riak langkah di terowongan drainase. | Act 1 Scene 3 (Terowongan Lontar) |
| `sfx_parchment_open.wav` | Suara membuka gulungan daun lontar kuno `[M]`. | Act 1 Scene 3 (Peta Lontar) |
| `sfx_dam_gears_creak.wav` | Derit berat roda kayu menara bendungan air bergerak. | Act 1 Scene 3 (Putar Katup Air) |
| `sfx_massive_water_rush.ogg` | Gemuruh air sungai purba dialihkan deras ke laut lepas. | Act 1 Scene 3 (Bendungan Terbuka) |
| `sfx_acid_steam_hiss.wav` | Desis uap asam dari kerak belerang danau yang mengering. | Act 1 Scene 4 (Danau Asam 2150) |
| `sfx_pipe_gun_cock.wav` | Suara kokang laras senapan pipa Maran (*KLIK-CLACK*). | Act 1 Scene 4 (Todongan Maran) |
| `sfx_stimpack_inject.wav` | Desis injeksi obat stimpack medis militer (*PSSSHT-BEEP*). | Act 1 Scene 4 (Pakai Stimpack) |
| `sfx_temple_gate_slam.wav` | Pintu gerbang batu kuil runtuh tertutup kabut hitam. | Act 1 Scene 5 (Jebakan Kuil) |
| `sfx_monster_screech_dark.wav` | Lolongan dingin mendirikan bulu kuduk Utusan Kala. | Act 1 Scene 5 (Spawn Monster) |
| `sfx_maran_snipe_burst.wav` | Tembakan kinetik senapan Maran (*DORRR-KRRRRSHHH!*). | Act 1 Scene 5 (Maran Snipe Cover) |
| `sfx_midair_foot_stomp.wav` | Hantaman sol sepatu Saka menginjak wajah Utusan 2 (*THUDDD!*). | Act 1 Scene 5 (QTE 2 Trampoline) |
| `sfx_monster_claw_clash.wav` | Benturan keras laras senapan Maran menahan cakar monster. | Act 1 Scene 5 (Maran Foreground) |
| `sfx_pasupati_unsheathe_ignite.wav` | Bilah keris tercabut dari batu & ledakan api spiritual (*SHINNNGG-FOOOOSHH!*). | Act 1 Scene 5 (Awakening Pasupati) |
| `sfx_fire_slash_hit.wav` | Suara tebasan api suci membelah monster kosmik (*SWHOOOSH-KABOOM!*). | Act 1 Scene 5 (Finisher Strike J) |
| `sfx_portal_padjadjaran_warp.wav` | Pusaran portal waktu melahap layar menuju Abad ke-14. | Act 1 Scene 5 (Penutup Act 1) |

---

### B. Background Music (BGM Tracks) — Komposisi Musik Arif

| Kode Track BGM | Judul & Mood Musik | Instrumen Utama | Lokasi di Game |
| :--- | :--- | :--- | :--- |
| `bgm_prolog_peaceful.ogg` | *"Fajar di Balik Kaca"* (Hangat, Nostalgik, Ringan) | Akustik Gitar Lo-Fi, Rhodes Piano, Synth Pad Lembut. | Prolog Scene 1 & 2 (Apartemen & Kedai Mak Inah) |
| `bgm_prolog_tragedy.ogg` | *"Saat Langit Menuntut"* (Tegang, Hektik, Kosmik) | Sub-Bass Berat, Strings Orkestra Cepat, Glitch Synth Distorsi. | Prolog Scene 3 (Tragedi Jembatan Pose Maestro) |
| `bgm_countdown_hectic.ogg` | *"Satu Menit Tersisa"* (Penuh Tekanan, Berdetik) | Clockwork Ticking, Fast Percussion Industrial, Alarm Synth. | Prolog Scene 4 & 5 (Dobrak Pintu & Brankas) |
| `bgm_sriwijaya_explore.ogg` | *"Angin Selat Wanua"* (Eksotik, Damai, Bersejarah) | Seruling Bambu, Gambus, Kendang Pesisir, Petikan Sape. | Act 1 Scene 1 (Pantai Pasir Putih & Galangan) |
| `bgm_sriwijaya_stealth.ogg` | *"Langkah di Balik Bayang"* (Tegang, Mengendap-endap) | Low-Pass Bassline, Detak Gamelan Pelog Minimalis, Shaker. | Act 1 Scene 2 & 3 (Stealth Pos Jaga & Pergudangan) |
| `bgm_maran_encounter.ogg` | *"Penyintas Badai Pertama"* (Misterius, Dingin, Grunge) | Distorted Electric Guitar Solitary, Rusting Metal Drone. | Act 1 Scene 4 (Pertemuan Maran di Danau Asam) |
| `bgm_act1_climax_battle.ogg` | *"Kobaran Pusaka Pasupati"* (Epik, Cepat, Menggelegar) | Gamelan Bali Gong Kebyar + Cyberpunk Bass Synth + Drum Orkestra. | Act 1 Scene 5 (Pertarungan 3 Gelombang & Cabut Keris) |

---

<div class="page-break"></div>

# BAGIAN IV: MATRIKS CHECKLIST INTEGRASI ENGINE (MARVIN & ARIF)

| Kategori Aset | Estimasi lama (perlu audit) | Format File | Penanggung Jawab | Status Integrasi |
| :--- | :---: | :---: | :---: | :---: |
| **Background Parallax Layers** | 20 File | `PNG RGBA (8-bit per kanal; alpha transparan)` (1920x1080 / 2560x1440) | Arif (Art) & Marvin (ParallaxBackground) | Belum diverifikasi — cek file dan integrasi |
| **Spritesheets & Character Cutouts** | 14 Karakter | `PNG RGBA (8-bit per kanal; alpha transparan)` Transparan | Arif (Rigging) & Marvin (AnimationPlayer) | Belum diverifikasi — cek file dan integrasi |
| **Interactive Props & Decals** | 28 File | `PNG RGBA (8-bit per kanal; alpha transparan)` Transparan | Arif (Art) & Marvin (Area2D / StaticBody2D) | Belum diverifikasi — cek file dan integrasi |
| **UI Windows, Modals, & Buttons** | 16 File | `PNG RGBA (8-bit per kanal; alpha transparan)` UI Atlas | Arif (Design) & Marvin (Control Nodes) | Belum diverifikasi — cek file dan integrasi |
| **Custom Shaders (GDShader)** | 4 Shader | `.gdshader` | Marvin (Code) & Arif (Visual Check) | Belum diverifikasi — cek file dan integrasi |
| **VFX Particles (`GPUParticles2D`)** | 10 Sistem | `.tscn` Sub-scenes | Marvin & Arif | Belum diverifikasi — cek file dan integrasi |
| **Sound Effects (SFX)** | 35 File | `.wav` / `.ogg` | Arif (Sound Engineer) | Belum diverifikasi — cek file dan integrasi |
| **BGM Original Soundtrack** | 7 Track | `.ogg` (Looping) | Arif (Composer) | Belum diverifikasi — cek file dan integrasi |

---

*Inventaris rencana produksi v0.2; jumlah dan ketersediaan aset belum diaudit. Act 2 adalah backlog.*  
*Arunika Studio — Kala: Singkap Garis Waktu.*
