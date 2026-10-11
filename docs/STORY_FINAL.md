# NASKAH CERITA & DIALOG (DRAFT ~60%, v0.2): KALA - SINGKAP GARIS WAKTU

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


## 0. STATUS NASKAH & ATURAN IMPLEMENTASI

### Kesiapan bagian cerita

| Bagian | Status produksi v0.2 |
| :--- | :--- |
| Prolog | Draft terperinci; review per scene sebelum diimplementasikan. Belum otomatis terkunci. |
| Act 1 | Draft terperinci; prioritas demo sesudah prototipe inti. |
| Act 2 | Draft berkembang; beberapa adegan Majapahit masih tergabung. Tidak masuk produksi demo. |
| Act 3 dan Epilog | Outline/arah ending; perlu pengembangan lebih lanjut. Tidak masuk produksi demo. |

Dialog dan lore yang sudah ada dipertahankan. Revisi ini menyelaraskan label, ID dan angka mekanik, bukan menambah dialog atau menyelesaikan 40% cerita yang tersisa.

### Format handoff per scene

Sebelum sebuah scene dibuat di Godot, isi: ID scene, prasyarat masuk, tujuan pemain, daftar aset, trigger, dialog/cutscene, pilihan dan flag, hasil sukses/gagal, checkpoint, serta scene tujuan. Dialog disimpan sebagai data terpisah dari controller supaya revisi tulisan tidak memerlukan perubahan logika gerak.

Flag awal yang disarankan: `prolog_tara_response` (protective/honest), `ki_pranata_route` (land/tunnel), `lontar_map_owned`, `chronos_belt_unlocked`, `dam_diverted`, `maran_response` (aggressive/focused), `pasupati_unlocked`. Nama ini baseline implementasi; gunakan ID yang sama di kode dan tracker.

Angka mekanik mengikuti baseline GDD v0.2: 5 Hati, maksimal 3 stok medkit, 1 medkit memulihkan 1 Hati, penalti Maran -1 Hati, reward +1 stok. Persentase HP bos tetap boleh dipakai. Arahan waktu/camera dalam naskah adalah target penyutradaraan yang diuji, bukan ukuran aset final.

Ungkapan dialog tentang Stimpack menutup 80 persen luka adalah deskripsi fiksi, bukan nilai healing gameplay; pemulihan tetap 1 Hati. Angka balans boss yang belum diuji tetap sementara.

### Peta ID scene dan bagian yang belum dipisahkan

- `pro_01`–`pro_05`: kamar, kedai/jembatan, tragedi, lorong, brankas/sabuk.
- `act1_01`–`act1_05`: pesisir, pos jaga, gudang/bendungan, Maran, kuil/Pasupati.
- `act2_01`–`act2_05`: curug, ngarai, reaktor, lab, punden/Maran.
- `act2_06`: gerbang Majapahit. Materi pengejaran/blind leap dan bengkel/Kunta saat ini masih tertulis dalam bagian ini.
- `act2_07`–`act2_09`: slot progresi yang ada dalam GDD (blind leap, bengkel/Kunta, barikade); naskah belum dipisahkan menjadi tiga scene mandiri. Jangan menganggap ketiganya selesai atau mengarang dialog untuk mengisi slot.
- `act2_10`: boss Tara Half-Vessel, sebelumnya salah dilabeli Scene 5.
- `act3_01`–`act3_02`: altar dan final boss; `epi_01`: epilog (satu rangkaian).

### Checklist review sebelum scene dikunci

- [ ] Tujuan pemain dan transisi masuk/keluar jelas.
- [ ] Dialog cocok dengan apa yang Saka ketahui pada titik cerita tersebut.
- [ ] Pilihan mengubah flag/hasil sesuai GDD, bukan sekadar teks.
- [ ] Kontrol cutscene/dialog tidak memicu movement atau combat bersamaan.
- [ ] Aset, emosi portrait, suara, dan animasi yang diperlukan tercatat.
- [ ] Pemilik proyek menyetujui versi scene; perubahan selanjutnya dicatat.

### Catatan kontinuitas untuk revisi berikutnya

1. Pose Tara melayang rendah pada awal manifestasi, kemudian terangkat tinggi di klimaks jembatan; kedua deskripsi adalah tahap berurutan.
2. Medan insulasi dasar sabuk sejak awal dan kemampuan penuh Level 4 perlu dibedakan dalam penjelasan late-game; jangan mengubah ending sebelum review penulis.
3. Dialog Maran/non-intervensi dan bantuan yang ia berikan perlu diperiksa konsistensinya; draft tetap dipertahankan.
4. Act 2–3, balans buff, dan urutan unlock akhir tetap backlog. Demo berakhir sesudah Pasupati dan layar To Be Continued.

---

**(Working Title: SAKA — Singkap Garis Waktu)**  
**Arunika Studio**  
**Dokumen Master Script, Worldbuilding, & Interactive Dialogue Branching**

---

## 1. DAFTAR KARAKTER & SPESIFIKASI POTRET EMOSI

1. **Saka (25 Tahun, Tinggi: 184 cm):** Protagonis. Arkeo-mekanik mandiri asal Astanapura (2150). Memiliki implan mata bionik (*Arkeo-Optics*) di mata kanannya yang berpendar biru/cyan. Karakter yang protektif, tekun, analitis, dan rela menyeberangi batas ruang dan waktu demi Tara.
   * *Spesifikasi Potret Ekspresi (Arif):*
     - `Saka_Ngantuk` : Mata kiri sayu, lensa mata bionik kanan meredup, rambut berantakan.
     - `Saka_Hangat` : Senyum tipis tulus, tatapan teduh saat menatap adiknya.
     - `Saka_Panik` : Pupil mengecil, lensa bionik berkedip merah tanda bahaya, rahang mengeras.
     - `Saka_Hancur` : Wajah syok, air mata menetes menatap adiknya terangkat di udara.
     - `Saka_Tekad` : Tatapan tajam tanpa ragu, lensa bionik menyala biru terang penuh tekad.
     - `Saka_Jarik_Santai` : Bertelanjang dada dengan balutan kain jarik tenun Sriwijaya & Chronos-Belt.
     - `Saka_Rompi_Pemburu` : Mengenakan rompi kulit tebal pemburu Padjadjaran, kain jarik, dan Chronos-Belt dengan tatapan siaga.
     - `Saka_Awakened_Pasupati` : Pupil menyala keemasan, menggenggam bilah Keris Pasupati yang membara.

2. **Tara (17 Tahun, Tinggi: 163 cm):** Adik perempuan Saka (Adek • Sahabat • Alasan). Ceria, tangguh, perhatian, keras kepala, dan selalu memakai liontin pemberian Saka. Memiliki darah murni penjaga kuno yang menjadikannya target utama Sang Hyang Kala.
   * *Spesifikasi Potret 5 State (Arif):*
     - `Adik_Ceria` : Senyum lebar, mata berbinar membawa sendok dan mangkuk sarapan.
     - `Adik_Cemberut` : Pipi menggembung mengomeli kebiasaan begadang kakaknya.
     - `Adik_Possessed_Maestro` : Mata menyala ungu supernatural tanpa pupil, pola retakan hitam di kulit, tanpa ekspresi manusia.
     - `Adik_Half_Vessel` : Sebagian wajah terbungkus kristal bayangan Kala, ekspresi batin yang tersiksa.
     - `Adik_Full_Vessel` : Wajah dingin tertelan sepenuhnya oleh aura kosmik kehampaan Kala.
     - `Adik_Lemas_Tersenyum` : Wajah pucat damai setelah terbebas dari ikatan Kala di pelukan Saka.

3. **Ki Pranata (60 Tahun):** Tetua pembuat perahu pesisir Wanua Sriwijaya (Abad ke-7). Bijak, hangat, bertelanjang dada dengan udeng tenun khas pesisir.
   * *Potret:* `KiPranata_Heran`, `KiPranata_Ramah`, `KiPranata_Peringatan`.

4. **Maran (Usia Tak Terhitung):** Sang Pengamat Abadi (*The Anomaly*). Pria misterius berjas usang dengan buku catatan kulit di luar aliran waktu. Muncul di tahun 2150 (berbekal senjata pipa) dan di tebing Padjadjaran mengamati deviasi waktu.
   * *Potret:* `Maran_Waspada`, `Maran_Netral`, `Maran_Kecewa`, `Maran_SenyumTipis`.

5. **Sang Hyang Kala / Utusan Kala:** Entitas purba pemangsa garis waktu yang bermanifestasi saat siklus ribuan tahun terbuka.
   * *Potret:* `Kala_Aura_Menakutkan`, `Utusan_Kala_Retak`.

---

# PROLOG: KETIKA DEWA TURUN
*(Setting: Megapolis Astanapura 2150 — Sektor Rusunawa & Jembatan Komersial)*

---

### **[pro_01] SCENE 1: Kamar Rusunawa Saka — Alarm Pagi & Pemindai Optik**
*(Layar fade in dari hitam. Suara alarm digital berdering berulang-ulang di kamar unit rusunawa Sektor Bawah Astanapura. Tara menepuk bahu Saka yang masih meringkuk di kasur dengan bantal busa).*

* **SFX:** *BIP-BIP-BIP... BIP-BIP-BIP! (Alarm jam digital).*

* `[TEXTBOX - Potret: Adik_Cemberut]`  
  **Tara:** "Kak Saka! Bangun, ih! Alarmnya udah jerit-jerit dari tadi masih aja merem. Kebiasaan banget begadang sampai subuh di depan meja solder... Perutku udah demo ini, Kak!"

* `[TEXTBOX - Potret: Saka_Ngantuk]`  
  **Saka:** *(Mengucek mata kirinya, lensa mata bionik kanannya berkedip biru redup)* "Hoamm... Iya, Tara, ini udah melek kok... Jam berapa emangnya?"

* `[TEXTBOX - Potret: Adik_Cemberut]`  
  **Tara:** "Udah mau jam delapan! Kalau Kakak sakit gara-gara kurang tidur, siapa yang mau jagain aku? Mana persediaan mie instan di lemari udah habis dari kemarin."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Tersenyum tipis, mengacak pelan rambut adiknya)*  
  "Iya, maaf ya. Semalem Kakak begadang nyelesein solderan modul konektor buat lensa bionik Kakak, nyocokin sama catatan lama Kakek doang. Makanya sampai lupa waktu. Nggak usah cemberut gitu, pagi ini Kakak yang traktir sarapan di luar."

* `[TEXTBOX - Potret: Adik_Ceria]`  
  **Tara:** "Beneran ya? Lontong kari di kedai seberang jembatan, kan? Pokoknya porsi jumbo pake telur!"

*(Pemain memegang kendali gerak `A` / `D` di dalam kamar. Pemain menekan `F` untuk mengaktifkan pemindai Arkeo-Optics, lalu menekan `E` di pintu kamar untuk keluar bersama Tara).*

---

### **[pro_02] SCENE 2: Jembatan Sektor Komersial & Kehangatan di Kedai Sarapan**
*(Scene ini terbagi menjadi dua bagian seimbang: **Fase 1 (Jalan di Jembatan)** dengan looping parallax dan dialog berjalan, lalu **Fase 2 (Kedai Makan)** dengan cutscene sarapan yang hangat).*

---

#### **BAGIAN A: Berjalan di Atas Jembatan Skybridge (Gameplay & Ambient Walk)**
*(Layar fade in: Saka dan Tara berjalan santai berdampingan di atas jembatan penyeberangan berpagar kaca. Sinar fajar keemasan memantul di kaca-kaca megastruktur Astanapura, kabut filter udara kota perlahan terangkat, dan rel maglev melintas di kejauhan).*

* `[TUTORIAL PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` untuk berjalan santai menikmati pemandangan fajar bersama Tara.*

* `[FLOATING BUBBLE 1 - Berjalan 5 meter]`  
  **Tara:** *(Merentangkan tangan menghirup angin pagi di balkon jembatan)*  
  "Wahh... seger banget! Tumben-tumbenan asap smog distrik bawah nggak bikin sesek fajar ini. Angin selatnya adem, langitnya juga oranye bersih!"

* `[FLOATING BUBBLE 2 - Berjalan 10 meter]`  
  **Saka:** *(Melirik adiknya sambil tersenyum tipis)*  
  "Iya. Jarang juga kamu bangun pagi tanpa disiram air. Biasanya jam segini masih molor meluk guling."

* `[FLOATING BUBBLE 3 - Berjalan 15 meter]`  
  **Tara:** *(Mengerucutkan bibir, lalu menatap Saka)*  
  "Enak aja! Aku kan bangun demi lontong kari... Eh tapi ngomong-ngomong, brankas besi peninggalan Kakek di kolong meja bengkel emang belum bisa dibuka ya, Kak? Penasaran banget aku isinya... Kakek beneran nggak pernah ngasih tahu kodenya?"

* **[INTERACTIVE DIALOGUE BRANCH 1]** *(Muncul di tengah jembatan)*
  * **PILIHAN A (PROTEKTIF / MERAHASIAKAN):**  
    * `[TEXTBOX - Potret: Saka_Hangat]`  
      **Saka:** "Boro-boro ngasih tahu. Kamu kayak nggak kenal Kakek aja, suka banget main teka-teki misterius. Kakek cuma pesen brankas itu cuma boleh dibuka kalau keadaan keluarga kita bener-bener darurat. Paling isinya ya prototipe sabuk besi tua yang dulu sering Kakek bangga-banggain. Jangan dipikirin, hari ini fokus habisin sarapanmu aja."  
    * `[TEXTBOX - Potret: Adik_Cemberut]`  
      **Tara:** "Ihh, selalu aja main rahasia-rahasiaan sama aku... Padahal aku kan udah bukan anak kecil lagi, Kak."  
    * **KONSEKUENSI (Emotional Echo):** Di Act 2, Gema Suara Tara terdengar sedih & kesepian: *"Kak Saka... kenapa Kakak bohong... aku sendirian..."*
  * **PILIHAN B (JUJUR / LORE DROP):**  
    * `[TEXTBOX - Potret: Saka_Hangat]`  
      **Saka:** "Kakek nggak pernah ngasih tahu kodenya, Dek. Tapi di catatan lamanya, Kakek bilang di dalem brankas itu ada prototipe sabuk pelindung keluarga yang Kakek rancang seumur hidup. Katanya sabuk itu dirakit khusus buat jaga-jaga kalau hari tergelap keluarga kita tiba. Makanya semalem Kakak penasaran banget nyolder kabel konektornya."  
    * `[TEXTBOX - Potret: Adik_Ceria]`  
      **Tara:** "Wih, peninggalan Kakek sekeren itu?! Kalau Kakak yang megang, aku yakin pasti beres. Siapa dulu dong montir nomor satu kebanggaanku!"  
    * **KONSEKUENSI (Buff Act 2):** Di awal pertarungan Boss Tara Act 2, Gema Tara memberi semangat: *"Kak Saka pasti bisa!"* ➔ Memberikan **Buff Regenerasi +1 Hati setelah 10 detik di awal pertarungan, maksimal 5 Hati (baseline backlog sementara)**.

* `[FLOATING BUBBLE 4 - Mendekati Ujung Jembatan]`  
  **Tara:** *(Mengendus udara dengan hidungnya, mata berbinar)*  
  "Tuh kan, baunya udah kecium sampai sini! Bumbu karinya Mak Inah emang nggak ada tandingannya. Cepetan jalannya, Kak!"

---

#### **BAGIAN B: Sarapan di Kedai Lontong Kari Mak Inah (Cozy Sit-Down & Heartwarming)**
*(Mereka tiba di teras kedai kayu Mak Inah yang asri menghadap selat. Dua mangkuk lontong kari panas tersaji di meja: lontong pulen, kuah kuning keemasan santan asli, telur rebus, tahu goreng, dan kerupuk aci).*

* `[TEXTBOX - Potret: Adik_Ceria]`  
  **Tara:** *(Menyambar kerupuk, mencelupkannya ke kuah, lalu menggigitnya cepat)*  
  "Nyam! A-aduh! Hah-hah... Panas banget lidahku!" *(Meringis sambil mengipasi mulutnya).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Tergelak pelan sambil menggeser segelas es teh tawar)*  
  "Kan... kebiasaan. Tiup dulu, Tara. Lontongnya nggak bakal kabur loncat ke selat kok. Seminggu cuma makan pasta ransum kaleng di rusun langsung kalap gini."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Membelah telur rebusnya lalu memindahkan separuh ke mangkuk Tara)*  
  "Nih, habisin telurnya. Biar ada gizinya, badanmu itu kurus banget."

* `[TEXTBOX - Potret: Adik_Cemberut]`  
  **Tara:** *(Menatap telur itu, lalu melihat lingkaran hitam di mata Saka dan lensa bioniknya yang berkedip lelah. Tara menaruh balik separuh telur itu ke mangkuk Saka).*  
  "Bagi dua, pokoknya nggak ada bantahan! Liat tuh mata bionik Kakak, kedip-kedip redup gara-gara lembur ngelas pipa. Kakak tuh kurus begini karena uangnya diabisin buat bayar sekolahku... Kakak juga harus makan bener, jangan minum kopi pait melulu!"

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Tersenyum kecil terharu, menyuap telurnya)*  
  "Iya, iya... bawel banget adik kesayangan Kakak ini."

* `[TEXTBOX - Potret: Adik_Ceria]`  
  **Tara:** *(Menatap cakrawala kota di luar jembatan dengan mata berbinar)*  
  "Kak... kalau sabuk Kakek udah stabil dan tembus paten, kita pindah dari rusun sempit ini ya? Cari tempat yang ada jendela gedenya, terus janji bawa aku jalan-jalan ke pantai selatan. Pantai beneran yang ada pasir putih sama ombaknya, bukan sekadar hologram dinding."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Menepuk lembut kepala Tara)*  
  "Iya, bocah. Janji. Nanti kita sewa hover-car tua, kita muter-muter pesisir berdua sampai kamu bosen."

* `[TEXTBOX - Potret: Adik_Ceria]`  
  **Tara:** *(Menyentuh lengan jaket Saka dengan hangat)*  
  "Kakak itu satu-satunya keluarga yang aku punya... Jangan paksain diri sampai sakit lagi ya, Kak."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Menggenggam tangan adiknya)*  
  "Tenang aja, Dek. Kakak bakal selalu ada di sini buat jagain kamu."

* `[TEXTBOX - Potret: Adik_Ceria]`  
  **Tara:** *(Tersenyum sangat manis dan bahagia)*  
  "Sip! Janji terkunci! Sekarang habisin sarapannya, habis ini Kakak temenin aku ke—"

*(Belum sempat Tara menyelesaikan kalimatnya, suara dengung megapolis mendadak sunyi senyap...)*

---

### **[pro_03] SCENE 3: Langit Robek & Tragedi Jembatan (Pose Maestro & Platforming Aksi)**
*(Scene ini memadukan tutorial platforming rintangan, visual sinematik megah, dan drama emosional kakak-beradik).*

---

#### **FASE 1: Kepanikan & Escape Run (Tutorial Sprint, Slide, & Jump)**
*(DETIK BERIKUTNYA, TANAH DAN JALUR JEMBATAN BERGUNCANG HEBAT SECARA ANOMALI! Sirine darurat Astanapura melolong histeris: "PERINGATAN! ANOMALI TEMPORAL KELAS-ALPHA TERDETEKSI DI SEKTOR 4! EVAKUASI SEGERA!". Gelas teh pecah, meja terbalik, dan kuah kari tumpah ruah).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Menyambar tangan Tara)* "Tara! Jembatannya mau runtuh! Pegang tangan Kakak erat-erat, lari sekarang!!"

* `[GAMEPLAY PROMPT]`  
  *Tahan `Shift` untuk Sprint lari ke kiri bersama Tara!*

*(Pemain berlari menggandeng Tara menembus badai getaran. Tiang reklame holo raksasa roboh melintang di depan mereka).*

* `[GAMEPLAY PROMPT]`  
  *Tekan `Ctrl` untuk **Slide** meluncur di bawah tiang reklame!*

*(Sebuah lempengan aspal jembatan di depan amblas ke selat).*

* `[GAMEPLAY PROMPT]`  
  *Tekan `Space` untuk **Jump** melompati jurang retakan!*

* `[FLOATING BUBBLE]`  
  **Tara:** *(Napas terengah-engah, memegangi kepalanya yang berdenyut aura ungu)*  
  "K-Kak Saka... sakit... kepalaku rasanya mau pecah! Di kupingku berisik banget ada suara aneh yang manggil-manggil... Kak, tolong...!"

---

#### **FASE 2: Awakening Kosmik & Pose Maestro (Zero Gravity)**
*(Tiba-tiba, sebuah pilar petir gravitasi ungu pekat menghantam tepat di antara mereka! Gelombang kejut sonik memisahkan cengkeraman tangan Saka dan Tara. Saka terpental membentur pembatas jembatan!).*

* `[SFX]` : *DUAAARRR-KZZZZT! (Ledakan gelombang waktu & distorsi gravitasi).*

* **VISUAL TRANSITION (THE ICONIC POSE MAESTRO):**  
  *Hukum gravitasi lenyap di area jembatan. Ribuan serpihan kaca, lempengan aspal beton, dan partikel neon terangkat melayang ke udara. Di tengah pusaran badai, **tubuh Tara melayang sepuluh meter di atas jembatan**! Rambut hitam panjangnya berkibar ke atas melawan gravitasi, kedua matanya menyala ungu kosmik tanpa pupil (*Possessed Awakening*), urat-urat retakan hitam bercahaya merambat di sekujur kulitnya, dan **KEDUA TANGANNYA TERENTANG LEBAR KE SAMPING DALAM POSE MAESTRO YANG SANGAT MEGAH NAN MENGERIKAN!***

* `[TEXTBOX - Potret: Adik_Possessed_Maestro]`  
  **Sang Hyang Kala (Suara Ganda Supernatural yang Berdentum di Langit):**  
  **"RIBUAN TAHUN KAMI MENUNGGU DI BALIK TIRAI KEHAMPAAN... AKHIRNYA, DARAH PENJAGA MURNI TELAH MEMBUKA GERBANG WAKTU!"**

* `[TEXTBOX - Potret: Saka_Hancur]`  
  **Saka:** *(Meringis bangkit dari aspal, lensa mata bioniknya berkedip merah panik)*  
  "TARA!! KELUAR DARI TUBUH ADIK GUA!! JANGAN SENTUH DIA!!"

---

#### **FASE 3: Desperate Rescue Platforming & Liontin yang Jatuh**
*(Portal retakan dimensi waktu hitam-keunguan raksasa terbuka berputar di belakang tubuh Tara. Gravitasi anomali mulai menyedot segala benda ke dalam singularitas!).*

* `[GAMEPLAY PROMPT]`  
  *Gunakan `A` / `D`, `Space` (Lompat Puing), dan `Ctrl` (Meluncur) untuk menerobos puing melayang mendekati Tara!*

*(Pemain mengendalikan Saka melompat dari satu lempeng aspal melayang ke lempeng berikutnya, menghindari balok besi yang tersedot vortex. Saka meloncat sekuat tenaga ke arah Tara! Ujung jari Saka hampir menyentuh jemari Tara!)*

* `[MOMEN EMOSIONAL KILAT]`  
  *(Aura ungu di mata Tara berkedip meredup sesaat. Kesadaran aslinya bocor keluar dalam rintihan tangis).*  
  * `[TEXTBOX - Potret: Adik_Cemberut]`  
    **Tara:** *(Menangis kesakitan, air mata menetes)* "K-Kak Saka... tolongin aku... badanku dingin banget... Kak, jangan tinggalin aku...!"

*(Tepat di detik itu, **KALA MELEPASKAN PULSA GRAVITASI MAHA DAHSYAT**!)*

* `[SFX]` : *BLASTTTTTT!*  
*(Gelombang kejut melempar Saka ratusan meter ke belakang hingga menghantam keras lantai jembatan. Tali leher Tara putus karena dorongan badai—**LIONTIN PEMBERIAN SAKA TERLEPAS DAN JATUH BERDENTING DI ASPAL DI SAMPING SAKA**).*

*(Portal waktu menelan tubuh Tara seutuhnya, lalu MENUTUP DENGAN LEDAKAN CAHAYA MEMBUTAKAN!).*

---

#### **FASE 4: Keheningan Pasca-Tragedi & Panggilan Pusaka**
*(Keheningan mencekam menyelimuti reruntuhan jembatan yang kini tinggal puing membara. Asap tebal mengepul dari kabel-kabel maglev yang putus).*

* `[CUTSCENE]`  
  *(Saka terbaring bersimbah darah di aspal. Tangannya yang gemetar bergerak meraih liontin Tara yang tergeletak di sampingnya. Saka menggenggam liontin itu erat-erat ke dadanya).*

* `[TEXTBOX - Potret: Saka_Hancur]`  
  **Saka:** *(Air mata menetes membasahi liontin)* "Tara... maafin Kakak... Kakak gagal..."

* `[SFX]` : *BIP... BIP... TINGGG! (Arkeo-Optics Boot Sequence).*

* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`  
  *`[PERINGATAN]: Resonansi Kronal Terdeteksi pada Partikel Udara!`*  
  *`[ANALISIS]: Target Tersedot Menembus Garis Waktu Purba.`*  
  *`[ERA STABIL TERDEKAT]: Bandar Wanua Sriwijaya — Tahun 682 Masehi.`*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Bangkit berdiri tegak, pupil mata bioniknya menyala biru terang penuh tekad membara)*  
  "Nggak... belum kelar. Gua nggak bakal biarin siapapun renggut Tara. Mau harus nyebrang ke ujung masa lalu sekalipun... gua bakal bawa adik gua pulang."

---

### **[pro_04] SCENE 4: Lorong Sektor Bawah & Dobrak Pintu Rusunawa (Rapid Tap E)**
*(Transisi layar: Saka berlari kencang menembus asap dan reruntuhan lorong Sektor 4, terengah-engah sambil menggenggam liontin Tara yang berlumuran debu dan darah. Saka tiba di depan pintu unit rusunawanya, tapi pintu geser baja terkunci total akibat protokol darurat).*

* `[SFX]` : *NGIIINNGGG... BIP-BIP! (Peringatan pintu macet merah).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Menghantam daun pintu dengan tinjunya yang bergetar)*  
  "Sialan!! Kenapa harus macet di saat kayak gini sih?! Buka, brengsek!! Adik gua baru aja diculik setan langit, lu malah ngunci pintu!!"

* `[GAMEPLAY INTERACTION]`  
  *Pintu darurat macet karena sistem lockdown sektor! Tekan tombol `E` berulang kali secepat mungkin (**Rapid Tap E / Button Mashing**) untuk mendobrak tuas manual!*

*(Pemain memencet `E` secepat mungkin. Progress bar mendobrak pintu terisi: 10%... 30%... 50%).*

* `[MID-MASHING DIALOGUE - Progres 50%]`  
  * `[TEXTBOX - Potret: Saka_Panik]`  
    **Saka:** *(Mendorong tuas baja hidrolik dengan sekuat tenaga sambil menggeram kalap)*  
    "Cepet kebuka, pintu sialan!! Jangan nahan gua... Tara lagi butuh gua sekarang, cepet bukaa!!"

*(Pemain terus menekan `E` hingga Progress Bar mencapai 100%).*

* `[SFX]` : *KRRRAAAK-BRAAAKK! (Engsel hidrolik patah, pintu baja jebol terbuka lebar).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menerobos masuk ke dalam unit apartemen)* "Hah... hah... gua nggak boleh telat!"

---

### **[pro_05] SCENE 5: Sudut Stash Bengkel, Hectic Countdown 60s, & Brankas Chronos-Belt**
*(Saka berlari melintasi ruang tengah apartemen menuju **Sudut Stash Bengkel** miliknya—ruangan partisi khusus berpintu kawat baja mirip ruang stash senjata V di Cyberpunk 2077, dipenuhi rak suku cadang, meja solder, terminal hologram, dan brankas baja berat peninggalan kakek. Lampu darurat merah berputar, plafon bergetar menjatuhkan debu, dan percikan api konsleting menyala di berbagai sudut).*

* `[SFX]` : *WUUU-WUUU-WUUU! (Sirine anomali kronal).*

* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`  
  *`[PERINGATAN KRITIS]: RESIKU HILANGNYA SINKRONISASI KRONAL!`*  
  *`[COUNTDOWN TIMER]: 00:59... 00:58... 00:57...`*  
  *(Jika timer mencapai 00:00 ➔ Game Over: "Garis Waktu Terputus — Eksistensi Tara Lenyap" ➔ Restart dari awal masuk kamar).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Panik melihat timer di matanya sambil menghambur ke meja stash)*  
  "Sial, sisa waktu sinkronisasinya tinggal semenit sebelum portal masa lalunya lenyap! Keadaan darurat... 'Hari tergelap' yang dulu Kakek maksud... jangan-jangan ini saatnya! Sabuk pelindung keluarga ada di brankas meja stash peninggalan Kakek!"

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Melihat keypad angka 4-digit di pintu brankas)*  
  "Kakek ngunci brankasnya pake 4 digit PIN... Waktu gua cuma semenit, gua harus cari tahu kodenya sekarang juga!"

* `[GAMEPLAY PUZZLE - 4 DIGIT KEYPAD BRANKAS]`  
  *Pemain memiliki waktu 60 detik untuk menemukan kode 4-digit dan membuka brankas hidrolik kakek:*
  1. **Opsi Scan Arkeo-Optics (`F`):**  
     * Pemain menekan `F` ke arah meja kerja untuk memindai bekas sidik jari termal kakek pada keypad angka: Angka `2`, `4`, `0`, `8` menyala biru.
  2. **Opsi Cek Terminal Komputer (`E`):**  
     * Pemain menekan `E` di layar komputer meja. Muncul catatan memo memoar kakek:  
       `[MEMO KAKEK]: "Kunci pengaman prototipe ini aku dedikasikan untuk hari kelahiran cucu perempuan kesayangan kita, Tara (24 Agustus)." ➔ KODE: 2408.`

* `[INTERAKSI KEYPAD BRANKAS]`  
  *Pemain mendekati brankas baja di bawah meja kerja, menekan `E`, lalu memasukkan 4 Digit PIN: **`2` `4` `0` `8`**.*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Mengetik angka di keypad dengan tangan gemetar)*  
  "Dua... empat... nol... delapan! Tanggal lahir Tara... Ayolah, kebuka...!"

* `[SFX]` : *PIIP-PIIP-PIIP... KLIK-CHUUUSSS! (Sistem hidrolik terbuka, desis uap nitrogen keluar).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Mata bionik berbinar haru menatap sabuk di dalam brankas)*  
  "Berhasil!! Kakek... dari awal Kakek emang udah nyiapin sabuk ini buat ngelindungin Tara..."

*(Pintu brankas terbuka lebar. Di atas bantalan busa magnetik, **Chronos-Belt (Level 1 Prototype)** bercahaya pendar cyan mistis, roda gigi jarum detiknya berdetik pelan).*

* `[GAMEPLAY PROMPT]`  
  *Tahan `E` (**Hold E**) untuk memasang Chronos-Belt ke pinggang dan menyambungkan kabel sinkronisasi Arkeo-Optics!*

*(Pemain menahan `E`. Saka menyambar sabuk, mengikatkannya ke pinggangnya, dan menancapkan jack kabel optik ke pelipis mata kanannya. Roda gigi Chronos-Belt berputar kencang, memancarkan medan pelindung kronal di sekeliling tubuh Saka).*

* `[SFX]` : *KLIK-KLAK-WHIRRRRRR! (Roda gigi sabuk berputar kencang).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menggenggam liontin Tara di tangan kirinya dan tuas sabuk di tangan kanannya)*  
  "Koordinat kekunci: **Bandar Wanua Sriwijaya, 682 Masehi**... Tunggu gua, Tara! Gua bakal bawa lu pulang, apapun yang terjadi!!"

*(Saka menarik tuas pemicu Chronos-Belt sekuat tenaga!)*

* `[SFX]` : *BLASTTTTT-ZWAAAASHHH! (Ledakan partikel prisma kronal menelan seluruh kamar).*

*(Layar memutih total dan melempar Saka menembus robekan aliran waktu menuju masa lalu!).*

---

# ACT 1: JEJAK YANG TERTINGGAL
*(Setting: Pesisir Wanua Sriwijaya, 682 Masehi & Reruntuhan Astanapura 2150)*

---

### **[act1_01] SCENE 1: Terdampar di Wanua Sriwijaya, Eksplorasi Pesisir, & Penyamaran Jarik**
*(Scene ini berfokus pada worldbuilding atmosfer abad ke-7, kontras fajar alami dengan masa depan 2150, eksplorasi santai, interaksi warga lokal, dan penyamaran pakaian tradisional).*

---

#### **BAGIAN A: Terbangun di Pantai Pasir Putih & Janji Laut Asli**
*(Layar fade in dari putih perlahan. Suara deburan ombak laut yang jernih dan kicauan burung camar pesisir. Saka terbaring di atas hamparan pasir putih bersih Selat Bangka tahun 682 Masehi, terbatuk pelan).*

* `[TEXTBOX - Potret: Saka_Ngantuk]`  
  **Saka:** *(Mengerjapkan mata kirinya, terbatuk menghirup udara)*  
  "Uhuk... hah... hah... Udara apa ini? Nggak ada bau asap knalpot... nggak ada bau uap kimia... Asin... ini bau garam laut asli?"

*(Saka bangkit berdiri, menyapu butiran pasir putih di telapak tangannya. Kamera menyorot bentangan laut biru jernih tanpa batas dan jajaran pohon kelapa yang melambai ditiup angin segar).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Menggenggam erat liontin Tara di dadanya, tatapannya berkaca-kaca)*  
  "Tara... kamu bener. Laut asli di luar hutan beton megapolis... indahnya kayak gini. Kakak janji, Kakak bakal bawa kamu ke sini nanti."

---

#### **BAGIAN B: Menyusuri Perkampungan Wanua & Interaksi NPC Pesisir**
*(Pemain mengendalikan Saka berjalan ke arah kanan `A`/`D` menyusuri pelataran desa pesisir Sriwijaya. Perahu-perahu cadik kayu bertiang tinggi bersandar di tepi dermaga, jaring nelayan dijemur di atas bambu, dan aroma ikan asin serta lada semerbak di udara).*

* `[TUTORIAL PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` untuk berjalan menyusuri perkampungan pesisir dan amati warga sekitar.*

* `[FLOATING BUBBLE - Dekat Anak Kecil Pesisir]`  
  **Bocah Nelayan (Leman):** *(Menunjuk-nunjuk mata bionik Saka sambil melongo takjub)*  
  "Mak, Mak! Liat abang aneh itu! Matanya ada lampu biru nyala kayak kunang-kunang laut!"

* `[INTERAKSI TEKAN E - Ibu Penjemur Ikan]`  
  * `[TEXTBOX - Potret: Saka_Hangat]`  
    **Saka:** "Permisi, Bu... ini beneran daerah perkampungan pesisir Wanua?"  
  * `[TEXTBOX - Potret: KiPranata_Heran]`  
    **Ibu Penjemur Ikan:** *(Menatap jaket tebal hitam-putih dan sepatu boots Saka dari atas sampai bawah dengan heran)*  
    "Aduh, Bujang... panas terik begini kenapa kau pakai baju tebal berlapis-lapis macam mau perang ke negeri kutub? Nanti kau pingsan kepanasan, anak muda!"

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka (Batin):**  
  *"Gawat... orang-orang ngeliatin gua kayak alien. Jaket sama mata bionik gua terlalu mencolok di era ini. Kalau ada prajurit patroli pelabuhan lewat, gua bisa langsung dituduh mata-mata dan dikurung. Gua butuh pakaian warga lokal sekarang juga."*

---

#### **BAGIAN C: Galangan Perahu Tradisional & Percabangan Dialog 2 (Ki Pranata)**
*(Saka tiba di sebuah pondok galangan perahu kayu di ujung dermaga. Seorang kakek tua berotot liat bertelanjang dada dengan udeng tenun kepala sedang memahat pasak kayu perahu cadik).*

* `[TEXTBOX - Potret: KiPranata_Heran]`  
  **Ki Pranata:** *(Mendongak kaget, hampir menjatuhkan beliung pahatnya)*  
  "Astaga Hyang Baruna! Makhluk dari pulau mana kau ini, anak muda?! Mengenakan pakaian tebal aneh berkilauan dan mata menyala seperti dedemit laut?!"

* **[INTERACTIVE DIALOGUE BRANCH 2]**
  * **PILIHAN A (INTIMIDATIF / BERBOHONG):**  
    * `[TEXTBOX - Potret: Saka_Tekad]`  
      **Saka:** "Gua saudagar kaya dari negeri jauh yang kapalnya karam! Jangan banyak tanya, Kek. Kasih gua pakaian biasa sekarang juga!"  
    * `[TEXTBOX - Potret: KiPranata_Peringatan]`  
      **Ki Pranata:** *(Memicingkan mata curiga dan dingin)*  
      "Sombong sekali bicaramu... Di tanah Sriwijaya, orang sombong biasanya jadi santapan buaya muara. Ambil kain bekas ini dan lekas pergi dari hadapanku sebelum kupanggil prajurit!"  
    * **KONSEKUENSI (Rute Sulit):** Rute area pergudangan dijaga lebih ketat (**+2 Prajurit Patroli Ekstra**).
  * **PILIHAN B (DIPLOMATIS / MEMOHON):**  
    * `[TEXTBOX - Potret: Saka_Hangat]`  
      **Saka:** "Maaf bikin Kakek kaget. Saya musafir yang tersesat, Kek... Kapal saya dihantam badai besar semalam. Saya cuma butuh kain biasa biar nggak bikin panik warga sini."  
    * `[TEXTBOX - Potret: KiPranata_Ramah]`  
      **Ki Pranata:** *(Tersenyum teduh, menaruh beliungnya)*  
      "Kasihan nian nasibmu, anak muda. Laut Selat Bangka memang suka menguji nyawa. Nih, pakai kain jarik tenunku ini. Karena kau berbudi halus, bawalah peta lontar tua ini. Di dalamnya ada jalur terowongan air kuno di balik semak pergudangan yang bisa membantumu menghindari prajurit patroli yang galak."  
    * **KONSEKUENSI (Jalur Pintas 40%):** Mendapatkan **`[Peta Lontar Tua]`** yang membuka terowongan drainase rahasia (memotong ~40% jalur stealth setelah prajurit tutorial pertama).

*(Cutscene Singkat: Saka melepas jaket tebal dan sepatunya, membebatkan kain jarik tenun khas pesisir di pinggangnya, bertelanjang dada dengan Chronos-Belt yang tetap melingkar kokoh di pinggang).*

* `[TEXTBOX - Potret: KiPranata_Ramah]`  
  **Ki Pranata:** "Nah, begini kau baru terlihat seperti pemuda pesisir yang gagah. Kalau kau mencari tempat aman atau ingin ke kuil tua di hulu kanal, hati-hatilah... Pagi tadi ada kilatan petir ungu aneh yang menyambar puncak kuil."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Mata bionik berkedip mengunci arah hulu kanal)*  
  "Petir aneh...? Itu pasti tempat Tara dibawa! Makasih banyak infonya, Kek. Saya pamit dulu!"

---

### **[act1_02] SCENE 2: Pos Penjagaan, Tutorial Stealth Stage 1, & Eureka Time-Switch `[Q]`**
*(Saka berjalan mendekati perbatasan zona pergudangan pelabuhan kerajaan. Di depan pos penjagaan, terdapat tumpukan peti kayu rempah dan semak-semak ilalang pesisir).*

---

#### **BAGIAN A: Micro-Cutscene Pos Penjagaan (Show, Don't Tell)**
*(Saka otomatis berhenti dan merunduk di balik tumpukan peti kayu. Kamera menyorot ke arah gerbang pos penjagaan kayu).*

* `[SFX]` : *CLANG-CLANG! (Hentakan gagang tombak prajurit).*

* `[TEXTBOX - Potret: KiPranata_Heran]`  
  **Pedagang Asing:** *(Memohon dengan tangan gemetar)*  
  "Tolonglah, Tuan Prajurit... Hamba cuma mau mengangkut karung beras ini ke hulu kanal..."

* `[TEXTBOX - Potret: KiPranata_Peringatan]`  
  **Prajurit Sriwijaya 1:** *(Membentak sambil mengarahkan ujung tombak)*  
  "Mana Surat Pas Cukai dari Syahbandar?! Tidak ada surat, tidak ada yang boleh melintasi gerbang ini! Lekas mundur sebelum ujung tombakku merobek dadamu!!"

*(Pedagang asing lari tunggang langgang ketakutan).*

* `[TEXTBOX - Potret: KiPranata_Peringatan]`  
  **Prajurit Sriwijaya 2:** *(Melirik ke arah semak dan peti luar)*  
  "Ayo periksa area semak dan tumpukan peti dermaga luar. Jangan sampai ada penyusup gelap atau pencuri rempah menyelinap!"

*(Kedua prajurit mulai bergerak patroli menyebar).*

---

#### **BAGIAN B: Tutorial Stealth Stage 1 (Prajurit 1 & Danger Zone QTE)**
*(Prajurit 1 menyusuri jalur semak dengan obor damar di tangannya).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka (Batin):** *(Menahan napas di balik peti)*  
  *"Gawat, prajurit itu jalan ke arah sini... Di depan ada rumpun semak ilalang tebal. Gua harus sembunyi!"*

* `[GAMEPLAY TUTORIAL PROMPT 1: MASUK SEMAK]`  
  *Gunakan `A` / `D` untuk mendekati semak ilalang, lalu tekan `[E]` untuk **Merunduk & Bersembunyi** di dalam semak.*

*(Pemain masuk ke semak dan menekan `E`. Tubuh Saka menjadi siluet gelap semi-transparan tanda tersembunyi. Namun, prajurit tiba-tiba berhenti persis di depan semak Saka karena curiga melihat goyangan ilalang!).*

* `[DANGER ZONE ACTIVATED — AUDIO-VISUAL IMMERSION]`  
  * **SFX Audio:** BGM meredup drastis (*Low-Pass filter*), suara detak jantung mendentum kencang di telinga (*Thump-thump... thump-thump...*) diiringi deru napas tertahan Saka.
  * **UI Timing Bar:** Muncul meteran bar horizontal di atas kepala Saka dengan jarum penunjuk yang bergerak bolak-balik melintasi area hijau (**Sweet Spot**).

* `[GAMEPLAY TUTORIAL PROMPT 2: TAHAN NAPAS / DETAK JANTUNG]`  
  *Prajurit berhenti tepat di depan semak! Tekan `[Klik Kiri]` atau `[E]` tepat saat jarum berada di dalam **Zona Hijau (Sweet Spot)** untuk menahan napas dan menenangkan detak jantung!*

*(Pemain menekan `[Klik Kiri]` / `[E]` tepat di Sweet Spot!).*

* `[TEXTBOX - Potret: KiPranata_Heran]`  
  **Prajurit Sriwijaya 1:** *(Mengamati rumpun ilalang, lalu menghela napas)*  
  "Hmm... tiada apa-apa. Rupanya hanya musang rawa yang melintas."

*(Prajurit 1 berbalik badan dan berjalan menjauh melanjutkan rute patrolinya).*

* `[GAMEPLAY TUTORIAL PROMPT 3: KELUAR SEMAK]`  
  *Situasi aman! Tekan `[Space]` untuk **Melompat Keluar dari Semak**.*

*(Pemain menekan `[Space]`. Saka melompat keluar dari semak dan merunduk di balik tumpukan karung lada kedua).*

---

#### **BAGIAN B (Lanjutan): Menyelinap Melewati Prajurit 2 (Pola Patroli & Timing Gerak)**
*(Di depan sana dekat gerbang utama, Prajurit 2 sedang berjaga menenteng tombak).*

* `[SFX]`: *Prajurit 2 menyeru dari kejauhan dengan nada Melayu klasik yang lantang.*

* `[TEXTBOX - Potret: KiPranata_Peringatan]`  
  **Prajurit Sriwijaya 2:** *(Menyeru dari arah gerbang)*  
  "Hai, Sanak! Gerangan apa yang berdesir di balik ilalang tadi?! Adakah kau jumpai penyusup gelap dari seberang selat?!"

* `[TEXTBOX - Potret: KiPranata_Ramah]`  
  **Prajurit Sriwijaya 1:** *(Menyahut dari kejauhan sambil mengangkat obor)*  
  "Tiada siapa-siapa! Hanya hembusan angin laut dan hewan rawa! Jalur pesisir luar aman terkendali!"

* `[TEXTBOX - Potret: KiPranata_Peringatan]`  
  **Prajurit Sriwijaya 2:** *(Mengangguk tegas, merapatkan cengkeraman tombaknya)*  
  "Baguslah kalau begitu. Tetap pasang mata dan telingamu! Jangan sampai ada mata-mata asing lolos ke hulu kanal, atau Datu Syahbandar akan murka pada kita berdua!"

*(Prajurit 2 mulai berjalan patroli bolak-balik: melangkah ke kanan membelakangi Saka ➔ berhenti mengawasi sudut pagar ➔ berputar kembali ke kiri).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka (Batin):** *(Mengamati ritme langkah Prajurit 2)*  
  *"Prajurit di depan mondar-mandir tiap beberapa detik... Begitu dia balik badan ngebelakangin gua, itu kesempatan buat nerobos ke balik pilar gerbang."*

* `[GAMEPLAY TUTORIAL PROMPT 4: MEMBACA POLA PATROLI]`  
  *Perhatikan arah hadap prajurit! Saat Prajurit 2 berjalan membelakangi kamu (Vision Cone mengarah ke kanan), segera tekan `A` / `D` untuk menyelinap maju ke balik pilar gerbang kayu!*

*(Pemain bergerak saat Prajurit 2 membelakangi Saka).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka (Batin):** *(Tiba dengan aman di balik dinding pilar gerbang utama)*  
  *"Beres. Dua penjaga pos depan udah lewat. Sekarang tinggal cari jalan nembus gerbang kayu ini..."*

---

#### **BAGIAN C: Rintangan Gerbang Kayu Ulin & Momen Realisasi Sabuk `[Q]`**
*(Saka maju beberapa meter ke depan. Jalur menuju area gudang utama terhalang oleh **Gerbang Kayu Ulin Raksasa** yang terkunci rapat dengan rantai baja tebal).*

* `[GAMEPLAY INTERACTION PROMPT]`  
  *Dekati gerbang kayu ulin, lalu tekan `[E]` untuk **Memeriksa & Mendorong Gerbang**.*

*(Pemain mendekati gerbang dan menekan `[E]`. Saka mencoba mendorong pintu gerbang dengan kedua tangannya, namun gerbang terkunci rapat dan rantai baja berdenting keras).*

* `[SFX]`: *KRRRKKK-KLANG! (Rantai baja beradu dengan kayu keras yang terkunci rapat).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Meringis sambil melepaskan tangannya dari kayu ulin yang keras)*  
  "Sial, gerbangnya digembok rantai dari dalam... Gua nggak punya kuncinya, pagarnya juga terlalu tinggi buat dipanjat."

*(Tepat setelah interaksi tersebut, kabel jack Arkeo-Optics dan roda gigi di sabuk Chronos-Belt di pinggang Saka mulai bergetar dan berdengung pelan. Lampu indikator LED di sabuk berubah menyala hijau terang!).*

* `[SFX]`: *HUMMMM... KLIK-KLAK! (Sabuk berdengung stabil).*

* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`  
  *`[DETEKSI ANOMALI]: Titik Resonansi Kronal Ditemukan!`*  
  *`[ANALISIS STRUKTUR]: Kayu Ulin Purba (682 M) — Status di 2150: 100% Lapuk & Runtuh Menjadi Abu.`*  
  *`[STATUS CHRONOS-BELT]: Modul Distorsi Temporal Lokal Siap Diaktifkan!`*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka (Batin):** *(Memandangi sabuk di pinggangnya dengan takjub sekaligus heran)*  
  *"Sabuknya berdengung lagi... Sejujurnya, gua cuma ngerakit alat ini murni ngikutin cetak biru yang ditinggalin Kakek di bengkel. Gua sendiri gak paham fisika kuantumnya kenapa alat ini bisa jalan... Tapi lensa bionik gua mendeteksi gerbang ulin ini udah rata dengan tanah di tahun 2150 pada koordinat yang sama persis."*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menarik napas dalam, memegang tuas sabuk dengan ragu)*  
  "Kakek pernah nulis di catatannya, kalau sabuk ini beresonansi di titik jangkar, tuasnya bisa ngegeser tubuh di koordinat yang sama antar waktu... Uji coba pertama di lapangan, semoga lu gak bikin badan gua kepotong dua ya, sabuk tua."

* `[GAMEPLAY TUTORIAL PROMPT: TIME-SWITCH PERTAMA KALI]`  
  *Sabuk mendeteksi **Zona Resonansi Waktu**! Tekan `[Q]` untuk melakukan **Time-Switch** melompati garis waktu ke tahun 2150!*

*(Pemain menekan `[Q]`. Realitas berkedip cepat memancarkan pendar prisma cyan. Lingkungan seketika berubah menjadi reruntuhan berasap Astanapura 2150. Gerbang kayu ulin tadi lenyap, menyisakan celah puing yang bebas dilewati).*

* `[TUTORIAL PROMPT]`  
  *Gunakan `A` / `D` untuk berjalan melangkah 5 meter melewati celah gerbang yang runtuh di tahun 2150!*

*(Saka melangkah melewati celah gerbang. Di depan jalurnya di tahun 2150 terhalang semburan pipa uap panas industri).*

* `[TUTORIAL PROMPT]`  
  *Tekan `[Q]` kembali untuk kembali ke tahun 682 Masehi di sisi dalam gerbang!*

*(Pemain menekan `[Q]`. Saka kembali ke era Sriwijaya 682 M—kini Saka telah berhasil masuk ke dalam **Area Pergudangan Utama**!).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Menghela napas panjang, tersenyum lega sambil menepuk sabuknya)*  
  "Hah... gila, catatannya Kakek beneran bekerja! Gua bisa manfaatin perbedaan kondisi waktu buat nembus rintangan fisik!"

---

* `[DEVELOPER & LEVEL DESIGN NOTE: TIME-SWITCH REJECTION FEEDBACK]`  
  *Jika pemain mencoba menekan `[Q]` di luar Zona Resonansi / Historical Anchor (misalnya saat di area stealth prajurit atau jalan setapak biasa):*  
  * **SFX:** *BZZT-KLIK! (Suara roda gigi sabuk macet / Error buzzer).*  
  * **Visual:** LED sabuk berkedip kuning-merah tanda tidak ada sinyal.  
  * **Floating Bubble Saka (Random Response):**  
    1. *"Roda giginya macet... Nggak ada resonansi kronal di sini. Sabuk ini cuma bisa aktif di titik-titik jangkar tertentu."*  
    2. *"Nggak ada sinyal resonansi. Sabuk ini nggak bisa dipake asal-asalan, bisa robek badan gua di ruang hampa."*  
    3. *"Percuma... gua cuma ngerakit sesuai cetak biru Kakek, tapi jelas alat ini gak bisa dipake di sembarang tempat."*

---

### **[act1_03] SCENE 3: Area Pergudangan Rempah, Pilihan Rute, & Puzzle Kausalitas Bendungan**
*(Layar fade in: Saka baru saja berhasil masuk ke sisi dalam gerbang ulin di tahun 682 Masehi. Saka melangkah beberapa meter ke depan menyusuri lorong kayu pembatas).*

* `[GAMEPLAY PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` untuk berjalan melangkah masuk mengamati area kompleks pergudangan.*

* `[AMBIENT OBSERVATION — Saka Berjalan 5 Meter]`  
  *(Kamera sedikit zoom-out memperlihatkan lanskap luas Kompleks Pergudangan Rempah Sriwijaya. Bau semerbak cengkeh, lada, dan kayu manis menguar di udara. Obor-obor minyak kelapa menyala di tiang-tiang tinggi, memperlihatkan siluet prajurit-prajurit bertombak yang sedang berpatroli).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka (Batin):** *(Berhenti di balik dinding sudut pilar, mengamati medan di depannya)*  
  "Ini dia area gudang utama pelabuhan... Luas banget. Tumpukan peti rempahnya berjejer sampai ke ujung dermaga kanal."

---

#### 🔍 **KONDISI A: JIKA BERSIKAP SOPAN / BAWA `[PETA LONTAR TUA]` (DEFAULT — 4 PRAJURIT)**
*(Lensa bionik Arkeo-Optics Saka menyorot sudut bawah pilar kayu di sebelah kirinya—terdapat kisi besi saluran air kuno yang tertutup lumut, sementara di jalur atas terlihat 4 prajurit patroli).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Melihat kisi besi di bawah, lalu menatap jalur atas)*  
  "Tunggu... itu kisi besi saluran pembuangan air yang dibilang Ki Pranata tadi! Di jalur lurus atas ada empat prajurit yang lagi patroli santai... Gua punya dua pilihan: merayap lewat terowongan bawah tanah pakai peta lontar biar aman, atau coba nyelinap lewat sela-sela peti rempah di atas."

* `[PILIHAN INTERAKSI DI LAYAR]`:
  * **Opsi 1 (Jalur Bawah Tanah):** Dekati kisi besi di kiri dan tekan `[E]` untuk masuk ke **Terowongan Drainase Air Kuno (Puzzle Peta Lontar [M])**.
  * **Opsi 2 (Jalur Atas Pergudangan):** Lanjut berjalan lurus ke arah tumpukan peti untuk masuk ke **Stealth Stage 2 (4 Prajurit Patroli)**.

---

#### 🔍 **KONDISI B: JIKA BERSIKAP SOMBONG / TANPA PETA (HARD MODE — 6 PRAJURIT)**
*(Kisi besi saluran air terkunci gembok tembaga berkarat tanpa petunjuk arah, sementara di jalur atas terlihat 6 prajurit patroli berobor yang bersiaga ketat).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Meringis menatap area depan yang dipenuhi prajurit)*  
  "Sial... prajurit patroli di depan ramai banget, ada enam orang mondar-mandir bawa obor. Karena gua gak punya peta terowongan bawah... nggak ada jalan lain selain nyelinap lewat kolong peti sama balik kain terpal rempah itu."

* `[PROMPT]`: *Lanjut berjalan lurus merunduk menuju **Stealth Stage 2 (Pergudangan Darat - Hard Mode 6 Prajurit)**.*

---

#### **BAGIAN A: Stealth Stage 2 & Navigasi Terowongan Air Kuno**
*(Di area pergudangan utama Sriwijaya 682 M, aroma tajam kayu manis dan lada hitam menyengat hidung. Obor damar minyak kelapa menyala di setiap tiang gudang kayu).*

---

##### 🌊 **RUTE 1: Terowongan Drainase Kuno (Memerlukan `[Peta Lontar Tua]` & 3 Persimpangan)**
*(Saka mendekati kisi besi saluran air kuno di sudut bawah pilar dinding).*

* `[GAMEPLAY PROMPT]`: *Tekan `[E]` untuk membuka kisi besi dan merayap masuk ke Terowongan Air Bawah Tanah.*
* `[GAMEPLAY TUTORIAL PROMPT: BUKA PETA]`: *Tekan `[M]` kapan saja untuk membuka **Peta Lontar Tua** dan memeriksa jalur saluran air yang aman.*
* `[FLOATING BUBBLE 1 - Saka]`:  
  **Saka (Batin):** *(Menyalakan senter mini Arkeo-Optics)*  
  "Lembap banget di bawah sini... baunya campuran lumut basah sama rempah kayu manis. Untung Kakek tadi ngasih peta lontar. Coba cek petanya dulu (`[M]`)."

**1. Persimpangan 1 (Suara Langkah di Atas Plafon):**

* *Kondisi:* Lorong terbelah menjadi cabang **Kiri** dan **Kanan**.
* *SFX:* Derap langkah sepatu prajurit terdengar jelas dari atas papan kayu sebelah kiri.
* `[FLOATING BUBBLE 2 - Saka]`: *"Ada suara derap langkah prajurit di atas plafon jalur kiri... Di peta lontar, jalur kanan adalah saluran air bersih yang bebas penjagaan."*
* *Pilihan Arah:*
  * **Belok Kanan (`BENAR`):** Lolos mulus ke lorong air bersih yang tenang.
  * **Belok Kiri (`SALAH / BUSTED`):** Palka terbuka di Gudang Senjata (*Reload Checkpoint*).

**2. Persimpangan 2 (Arus Air & Sarang Buaya Muara):**

* *Kondisi:* Lorong terbelah menjadi **Lurus** dan **Belok Kiri**.
* *SFX:* Gemuruh aliran air deras mengalir ke lubang pembuangan gelap di depan.
* `[FLOATING BUBBLE 3 - Saka]`: *"Arus airnya kencang banget ke arah depan... Kata simbol di peta, jalur lurus ini buangan limbah ke sarang buaya muara. Gua harus belok kiri ke pipa ventilasi kering."*
* *Pilihan Arah:*
  * **Belok Kiri (`BENAR`):** Naik ke undakan batu kering dengan ventilasi segar.
  * **Lurus (`SALAH / BUSTED`):** Tergelincir ke muara terbuka depan pos jaga (*Reload Checkpoint*).

**3. Persimpangan 3 (Dua Lubang Palka Menuju Cahaya):**

* *Kondisi:* Ujung saluran air, terlihat dua lubang palka di atas: Palka **Lurus** dan Palka **Kanan**.
* `[FLOATING BUBBLE 4 - Saka]`: *"Udah dekat ujung... Satu palka tembus ke barak prajurit, satu lagi ada gambar perahu—pintu air tepi kanal! Jangan sampai salah buka tutup palka."*
* *Pilihan Arah:*
  * **Belok Kanan (`BENAR / EXIT`):** Saka mendorong kisi palka kanan (`[E]`) dan keluar dengan selamat di balik semak rimbun tepat di sebelah **Pintu Air Tepi Kanal Sungai** (Scene 3 Bagian B)!
  * **Lurus (`SALAH / BUSTED`):** Palka terbuka di tengah ruang barak prajurit (*Reload Checkpoint*).

---

##### 📦 **RUTE 2: Jalur Atas Pergudangan Darat (Stealth Manual Peti & Terpal)**
*(Saka merunduk menyelinap melintasi lorong-lorong sempit di antara gunungan peti kayu manis dan karung goni rempah).*

**1. Fase 1: Tumpukan Peti Kayu Manis (Prajurit 1 & 2 Patroli Silang)**

*(Saka berjongkok masuk ke kolong rak peti kayu manis `[E]` saat dua prajurit berpapasan di depan lorong).*

* `[FLOATING BUBBLE - Prajurit Sriwijaya 1]`: "Aduh... gatal nian leherku sedari tadi dihisap nyamuk rawa pesisir."
* `[FLOATING BUBBLE - Prajurit Sriwijaya 2]`: "Tahanlah sedikit, Sanak. Usai muatan kapal saudagar dari Champa ditimbang, giliran jaga kita selesai."
* `[FLOATING BUBBLE - Saka (Batin)]`: *"Dua prajurit di depan lagi asyik ngobrol... Ini celah buat nyebrang ke balik terpal karung lada di sebelah kanan."*

*(Pemain menekan `[Space]` untuk keluar dari kolong peti saat kedua prajurit saling membelakangi, lalu menyelinap maju).*

**2. Fase 2: Area Timbangan Rempah & Tirai Terpal Goni (Prajurit 3 & 4)**

*(Saka menyusup ke balik kain terpal karung goni rempah `[E]`. Prajurit 3 tiba-tiba melangkah mendekat dan berhenti persis di depan terpal Saka untuk memeriksa neraca timbangan).*

* `[DANGER ZONE ACTIVATED — AUDIO-VISUAL IMMERSION]`  
  * **SFX Audio:** Detak jantung mendentum kencang (*Thump-thump...*) & helaan napas tertahan Saka.  
  * **UI Timing Bar:** Jarum bergerak melintasi **Sweet Spot Hijau**.  
  * *Tekan `[Klik Kiri]` atau `[E]` di Sweet Spot untuk menahan napas!*
* `[FLOATING BUBBLE - Prajurit Sriwijaya 3]`: *"Hmm... rupanya catatan timbangan cengkeh ini sudah lengkap dicap Syahbandar."*
* `[FLOATING BUBBLE - Saka (Batin)]`: *"Jangan nengok ke balik terpal... berbaliklah... terus jalan..."*

*(Prajurit 3 berputar badan dan melangkah pergi. Saka menekan `[Space]` untuk keluar dari balik terpal).*

**3. Fase 3: Pintu Gerbang Tepi Kanal (Menuju Scene 3 Bagian B)**

* **Kondisi A (Jika Rute Diplomatis — 4 Prajurit Default):**  
  * `[FLOATING BUBBLE - Saka (Batin)]`: *"Prajurit keempat udah jalan ke arah dermaga barat... Jalur ke pintu gerbang kanal udah bersih!"*  
  * *(Saka berlari kecil keluar melewati gerbang kayu belakang gudang menuju tepi kanal sungai).*
* **Kondisi B (Jika Rute Sombong — 6 Prajurit Hard Mode):**  
  * *(Dua prajurit ekstra bertombak panjang berdiri bersiaga di kedua sisi gerbang luar).*  
  * `[FLOATING BUBBLE - Prajurit Sriwijaya 5]`: "Tetap pasang matamu, Sanak! Kata tetua galangan perahu tadi, ada orang asing berbusana aneh yang mencurigakan berkeliaran di pesisir."  
  * `[FLOATING BUBBLE - Prajurit Sriwijaya 6]`: "Tenang saja. Tiada seekor musang pun yang sanggup lolos dari mata tombak kita."  
  * `[FLOATING BUBBLE - Saka (Batin)]`: *"Tuh kan... Kakek galangan tadi beneran ngelapor gara-gara gua sombongin. Gua harus meluncur di kolong gerobak lada pas mereka berdua noleh ke arah obor."*  
  * *(Pemain menekan `[Ctrl]` untuk meluncur di bawah gerobak kayu saat kedua prajurit menoleh, lalu berhasil lolos ke tepi kanal sungai).*

---

#### **BAGIAN B: Menyusuri Tepi Kanal & Refleksi Batin Saka (Ambient Walk)**
*(Layar transisi: Saka keluar dari kompleks gudang ke jalan setapak tanah di tepi kanal sungai Sriwijaya yang tenang. Suara gemercik air sungai yang jernih, desau angin membelai pelepah kelapa, dan kicauan burung rawa pesisir menggantikan ketegangan sebelumnya).*

* `[GAMEPLAY PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` untuk berjalan santai menyusuri jalan setapak tepi kanal sungai menuju ke arah hulu.*

* `[FLOATING BUBBLE 1 — Berjalan 3 Meter]`  
  **Saka (Batin):** *(Menarik napas panjang menghirup angin sungai yang segar)*  
  "Seger banget... Pertama kalinya seumur hidup paru-paru gua gak kemasukan debu filter AC rusunawa. Pakaian jarik tenun ini... anehnya adem juga dipakai di cuaca pesisir."

* `[FLOATING BUBBLE 2 — Berjalan 8 Meter]`  
  **Saka (Batin):** *(Meraba liontin logam Tara di dadanya yang terasa dingin)*  
  "Dulu Tara selalu cerewet tiap kali ngeliat gua ngurung diri di meja solder... *'Kak, masa hidup kita cuma muter-muter dari kamar sempit ke kedai sarapan doang? Kapan kita bisa liat sungai asli?'*... Andai kamu ada di sini sekarang, Dek."

* `[FLOATING BUBBLE 3 — Berjalan 14 Meter]`  
  **Saka (Batin):** *(Mendongak menatap struktur menara kayu raksasa dan siluet puncak kuil di hulu)*  
  "Di depan sana ada menara bendungan air raksasa... dan di baliknya, kuil tua tempat kilatan petir ungu tadi. Sinyal resonansi Tara makin kuat. Tunggu gua, Dek... gua udah makin dekat."

---

#### **BAGIAN C: Menara Bendungan Sriwijaya & Puzzle Kausalitas Danau Asam**
*(Saka tiba di area tepi sungai besar di depan struktur megah **Menara Bendungan Air Tradisional Sriwijaya**).*

**1. Fase 1: Sinyal Resonansi Tara di Koordinat 2150**

*(Lensa mata bionik Arkeo-Optics Saka berkedip cepat dan sabuk Chronos-Belt berdengung stabil).*

* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`:  
  *`[TARGET KRONAL TARA]: Resonansi Jiwa Terdeteksi Berasal dari Reruntuhan Kuil di Tahun 2150!`*  
  *`[STATUS SABUK]: Zona Resonansi Waktu Aktif — Siap Melompat ke 2150 [Q]!`*
* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Melihat koordinat di matanya)*  
  "Sinyal resonansi Tara berasal dari reruntuhan kuil di masa depan... Sabuknya udah aktif. Gua harus cek kondisi jalan masuk kuil di tahun 2150."
* `[GAMEPLAY PROMPT]`: *Tekan `[Q]` untuk melompat ke tahun 2150 mengecek akses menuju kuil!*

**2. Fase 2: Rintangan Danau Limbah Asam (Astanapura 2150)**

*(Pemain menekan `[Q]`. Realitas berkedip ke tahun 2150. Di depan Saka, pemandangan asri sungai lenyap, berganti menjadi **Danau Limbah Asam Hijau Beracun** yang bergolak menenggelamkan seluruh lembah dan pintu masuk kuil!).*

* `[SFX]`: *PZZZZT-BURRRRP! (Suara uap gelembung asam kimia meletup).*
* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka (2150):** *(Mundur selangkah, menatap danau hijau berbusa)*  
  "Astaga... sungainya berubah jadi danau limbah pabrik beracun! Jalur masuk kuilnya tenggelam total di bawah asam."
* `[GAMEPLAY INTERACTION: SCAN AIR DENGAN [F]]`: *Arahkan kursor dan tekan `[F]` untuk memindai zat kimia dan asal pasokan air danau!*
* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`:  
  *`[ANALISIS KIMIA]: Asam Sulfat Korosif pH 1.1 — Korosi Organik 98%! Fatal jika tersentuh.`*  
  *`[ANALISIS KAUSALITAS]: Danau terbentuk dari akumulasi aliran sungai purba selama 1400 tahun (Sejak 682 M).`*  
  *`[SOLUSI REKAYASA TEMPORAL]: Jika debit sungai di era 682 M dialihkan ke laut, danau limbah di tahun 2150 akan kehilangan pasokan dan surut mengering!`*
* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Tersenyum memahami solusi kausalitas)*  
  "Bagus... danau asam ini cuma ada karena air sungainya ngalir terus selama seribu tahun lebih. Di era 682 M tadi ada Menara Bendungan... Kalau katup bendungannya gua putar buat buang air sungai langsung ke laut lepas, danau asam ini bakal kering kerontang!"
* `[GAMEPLAY PROMPT]`: *Tekan `[Q]` kembali ke tahun **682 Masehi** untuk memanipulasi katup bendungan!*

**3. Fase 3: Manipulasi Katup Bendungan (Era Sriwijaya 682 M)**

*(Pemain menekan `[Q]` kembali ke 682 M. Saka menaiki tangga kayu Menara Bendungan Sriwijaya menuju puncak anjungan).*

* `[GAMEPLAY INTERACTION]`: *Dekati roda kemudi katup air kayu besar di puncak menara, lalu tahan `[E]` (**Hold E**) selama 3 detik untuk memutar katup bendungan!*

*(Pemain menahan `[E]`. Saka memutar roda kemudi dengan sekuat tenaga! Suara gemuruh roda gigi kayu berputar, pintu bendungan terbuka lebar, dan seluruh debit air sungai teralihkan berbelok langsung ke laut lepas Selat Bangka!).*

* `[SFX]`: *KRRRKKK-BRAAAKK... RUUUMMMBBLE-WSHHHH! (Gemuruh air sungai teralihkan ke laut).*
* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`:  
  *`[PERUBAHAN KAUSALITAS BERHASIL]: Garis Waktu 2150 Telah Diperbarui!`*  
  *`[STATUS 2150]: Danau Limbah Asam Telah Mengering Total Menjadi Lembah Tandus!`*
* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** "Kausalitas berhasil diubah! Sekarang jalur kuil di 2150 udah aman dilewati!"
* `[GAMEPLAY PROMPT]`: *Tekan `[Q]` untuk kembali ke tahun **2150** dan menyeberangi dasar danau yang telah mengering!*

*(Pemain menekan `[Q]`. Saka melangkah turun menyeberangi dasar danau yang kini menjadi lembah batu kering... menuju Scene 4!).*

---

### **[act1_04] SCENE 4: Lembah Danau Asam yang Mengering & Pertemuan Perdana dengan MARAN**
*(Setting: Astanapura 2150 — Dasar Danau Limbah Asam yang Baru Saja Mengering).*

---

#### **BAGIAN A: Menuruni Lembah Berbatu & Eksplorasi Dasar Danau**
*(Layar fade in: Saka melompat turun dari tebing bendungan ke dasar danau yang kini mengering total. Permukaan tanah dipenuhi kerak belerang kuning-kehijauan yang retak-retak, uap kimia tipis mendesis keluar dari celah batu, dan bangkai silinder filter limbah raksasa berkarat setengah terkubur di lumpur kering).*

* `[GAMEPLAY PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` untuk berjalan menyeberangi dasar danau asam menuju reruntuhan kuil di seberang lembah.*

* `[FLOATING BUBBLE 1 — Saka Berjalan 4 Meter]`  
  **Saka (Batin):** *(Menutup hidung dari bau uap belerang)*  
  "Bau uap kimianya nyengat banget... Liat garis kerak asam di dinding tebing itu, tingginya hampir sepuluh meter. Kalau gua gak ngalihin bendungan di era Sriwijaya tadi, gua pasti udah jadi abu larut di sini."

* `[INTERAKSI OPSIONAL SCAN DENGAN [F] — Bangkai Pipa Industri]`  
  * `[HUD OVERLAY]`: *`[OBJEK]: Pipa Pembuangan Kimia Industri 2150 — Status: Kering & Korosi Mati Akibat Penghentian Pasokan Air Purba 1400 Tahun Lalu.`*  
  * `[FLOATING BUBBLE 2 - Saka]`: *"Keren juga efek kausalitas... Pipa limbah kota masa depan ini mati total cuma gara-gara satu katup kayu di masa lalu."*

---

#### **BAGIAN B: Todongan Senjata Rakitan & Konfrontasi dengan MARAN**
*(Saka mendekati gerbang batu reruntuhan kuil di ujung lembah. Tiba-tiba terdengar suara kokangan senjata taktis berdering tajam dari balik bangkai pipa raksasa!).*

* `[SFX]`: *KLIK-KRAK! (Kokangan Senjata Rakitan Serbaguna).*

* `[CUTSCENE MICRO]`  
  *(Seorang pria berambut merah marun bertubuh jangkung mengenakan jaket taktis hitam ber-harness melangkah keluar dari balik bayangan pipa. Di pergelangan tangan kirinya menyala modul Arkeo-Scanner, sementara tangan kanannya menodongkan moncong Senjata Rakitan Serbaguna tepat ke dada Saka).*

* `[TEXTBOX - Potret: Maran_Waspada]`  
  **Maran:** *(Mata merahnya menatap tajam dari balik poni rambut marunnya, terperangah melihat Saka)*  
  "Berhenti di situ! Jangan bergerak selangkah pun! Siapa kau? Bertelanjang dada mengenakan kain jarik pesisir seribu tahun lalu... tapi di pinggangmu melingkar sabuk distorsi kronal?"

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Meringis kaget, mengangkat kedua tangannya setengah)*  
  "Lu siapa?! Turunin moncong senjata lu dari muka gua!"

* `[TEXTBOX - Potret: Maran_Terkejut]`  
  **Maran:** *(Modul scanner di lengannya berkedip membaca frekuensi sabuk Saka)*  
  "Aku yang bertanya! Kau baru saja memicu pergeseran kausalitas besar... Danau limbah asam ini surut mengering dalam hitungan menit karena manipulasi aliran air di masa lalu. Kau manusia 2150 yang berjalan mundur melintasi waktu... Dari mana kau dapatkan cetak biru sabuk itu?!"

---

#### ⚖️ **[INTERACTIVE DIALOGUE BRANCH 3]**

* **PILIHAN A (AGRESIF / EMOSIONAL):**  
  * `[TEXTBOX - Potret: Saka_Tekad]`  
    **Saka:** "Nyingkir dari jalan gua! Gua gak punya waktu buat ngeladenin orang asing bawa senjata! Minggir!!"  
  * `[SFX]`: *DORRR! (Tembakan meletus).*  
  * `[CUTSCENE / PENALTY]`  
    *(Maran menarik pelatuk! Peluru menyerempet bahu kiri Saka, menimbulkan luka sobek berdarah).*  
  * `[TEXTBOX - Potret: Saka_Panik]`  
    **Saka:** *(Memegangi bahunya yang berdarah, meringis)* "Arghh... sialan lu!!"  
  * `[TEXTBOX - Potret: Maran_Waspada]`  
    **Maran:** *(Menurunkan senjata dengan tatapan dingin dan sinis)*  
    "Gegabah... Orang yang cuma modal nekat dan emosi bakal mati dalam tiga detik di dalam sana. Masuklah, dan biarkan kebodohanmu membunuhmu sendiri."  
  * *(Maran melangkah mundur menghilang di balik kabut reruntuhan).*  
  * **KONSEKUENSI GAMEPLAY (Status Penalty):** **Saka kehilangan 1 Hati saat ini; Hati maksimal tetap 5** saat memasuki pertarungan di dalam Kuil!

---

* **PILIHAN B (FOKUS PADA TARA / DIPLOMATIS):**  
  * `[TEXTBOX - Potret: Saka_Tekad]`  
    **Saka:** *(Menatap lurus mata Maran, meraba liontin logam di dadanya)*  
    "Turunkan senjata lu! Gua gak peduli soal teori kausalitas... Adik gua, Tara, diculik sama entitas dewa langit tadi pagi! Gua bakal nyebrang ke ujung waktu manapun buat bawa adik gua pulang!"  
  * `[TEXTBOX - Potret: Maran_Pahit]`  
    **Maran:** *(Terdiam sejenak, tatapan dinginnya melunak menatap liontin Saka, ekspresinya berubah pahit mengingat masa lalunya)*  
    "Adikmu...? Menyelamatkan keluarga yang direnggut waktu... heh."  
  * `[TEXTBOX - Potret: Maran_Waspada]`  
    **Maran:** *(Menurunkan senjatanya, lalu merogoh ransel modularnya)*  
    "Entitas non-linear itu, Sang Hyang Kala, sedang mengeksploitasi darah murni adikmu untuk dijadikan wadah ragawinya (*Vessel*). Di dalam kuil itu, Utusan Kala sudah menunggu. Kalau kau masuk dengan tangan kosong, kau cuma bakal mati sia-sia. Ambil ini."  
  * *(Maran melempar sebuah tabung injektor medis taktis ke arah Saka).*  
  * `[TEXTBOX - Potret: Saka_Hangat]`  
    **Saka:** *(Menangkap stimpack medis)* "Ini... stimpack medis militer 2150? Lu... siapa sebenarnya?"  
  * `[TEXTBOX - Potret: Maran_Waspada]`  
    **Maran:** *(Memeriksa modul Arkeo-Scanner di lengannya)*  
    "Hanya seorang penyintas yang gagal melindungi keluarganya saat badai waktu pertama... Cari pusaka bermata bilah api di atas altar kuil. Hanya pusaka kuno yang mampu melukai anomali waktu."  
  * *(Maran berbalik badan dan melangkah pergi di antara kabut).*  
  * **KONSEKUENSI GAMEPLAY (Item Reward):** Mendapatkan **`[Stimpack Medis 2150]`** (**+1 stok medkit, kapasitas tetap 3; tidak menambah slot permanen**)!

---

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menggenggam stimpack / menahan bahunya, menatap pintu gerbang batu kuil)*  
  "Pusaka bermata api... Gua harus ambil pusaka itu dan hancurin monster di dalam sana!"

*(Pemain melangkah masuk ke dalam Gerbang Altar Kuil Kuno... Menuju Scene 5!).*

<div class="page-break"></div>

### **[act1_05] SCENE 5: Ruang Altar Kuil Kuno & Kebangkitan Keris Pasupati (Klimaks Act 1)**
*(Setting: Interior Ruang Altar Kuil Kuno, Sisi Reruntuhan Lembah 2150)*  
*(Latar: Ruang aula batu raksasa bergaya candi megalitikum purba yang tertimbun puing reruntuhan futuristik 2150. Di tengah ruangan, sebuah altar batu punden berundak memancarkan cahaya pijar keemasan. Di atas altar batu, bilah Keris Pasupati menancap kokoh, bilahnya berlekuk (luk) dan diselimuti bara api spiritual yang tak kunjung padam).*

---

#### **BAGIAN A: Cutscene Pembuka — Hilangnya Tara & Jebakan Utusan Kala**

*(Saka melangkah cepat melintasi ambang pintu gerbang batu kuil yang remang-remang. Debu kronal beterbangan di udara. Lensa bionik Arkeo-Optics milik Saka berkedip-kedip cepat menangkap jejak partikel ungu).*

* `[SFX]`: *WSHHHH... BZZZT... (Suara dengung resonansi temporal).*
* `[CUTSCENE / CINEMATIC CAMERA]`  
  *Kamera bergerak naik menuju pelataran tertinggi altar. Di depan punden berundak, tampak siluet hologram Tara dalam wujud **Possessed Awakening** (tubuhnya melayang 20 cm dari lantai dengan kedua tangan terentang lebar dalam pose maestro, dikelilingi kabut ungu pekat). Sinyal partikel tubuh Tara perlahan terdistorsi dan tersedot masuk ke dalam celah retakan portal waktu raksasa di dinding belakang kuil.*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Berlari maju dengan tangan terulur ke arah altar)*  
  "TARA!! TUNGGU!! TARA—!!"

* `[SFX]`: *BLAAMMM!! (Gerbang batu kuil runtuh tertutup reruntuhan puing & kabut kosmik hitam pekat).*
* `[SFX]`: *KRRRRSSSHHH... HWOOOOSH! (Suara lolongan dingin mendirikan bulu kuduk).*

*(Tiga pusaran kabut bayangan kosmik bermanifestasi di dalam ruangan. Tiga makhluk mengerikan bertubuh kabut hitam pekat dengan mata ungu menyala dan cakar bayangan temporal—**Tiga Utusan Sang Hyang Kala**—muncul mengepung ruangan! Saka terhenti kaku, menatap kedua tangannya yang kosong tanpa senjata).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Meringis mundur, menatap monster bayangan di depannya)*  
  "Sialan... Tiga monster anomali sekaligus?! Gua bahkan belum punya senjata buat nyentuh makhluk ini...!"

---

#### **BAGIAN B: Gelombang 1 — Serangan dari Langit-Langit & Tembakan Maran (Background Layer)**

*(Utusan Kala 1 merayap cepat di langit-langit kubah kuil, lalu menukik tajam ke arah kepala Saka dengan cakar terhunus!)*

* **[QUICK TIME EVENT (QTE 1) — EVASIVE JUMP]**
  * **Prompt Layar:** `[TEKAN TOMBOL SPACE (LOMPAT MENGHINDAR)]` *(Window Waktu: 1.5 Detik)*
  * **Eksekusi:** Saka melompat dan berguling ke kanan tepat saat cakar Utusan 1 menghantam lantai batu (*CRACKKK!*).

*(Tepat saat Utusan 1 bersiap menerkam Saka yang masih terduduk di lantai...)*

* `[SFX]`: *DORRR-BZZZZTTT!! (Tembakan kinetik bermuatan energi kronal memecah keheningan).*
* *(Kamera menyorot cepat ke arah **Background Layer (Lantai 2 Balkon Reruntuhan)**. Maran berdiri kokoh membidikkan senapan pipa pengikisnya dari kejauhan!).*
* *(Peluru Maran menghantam telak kepala Utusan 1. Monster itu melolong melengking dan meledak menjadi debu partikel temporal abu-abu!).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Menoleh ke balkon atas latar belakang dengan napas memburu)*  
  "Maran?! Lu ngikutin gua?!"

* `[TEXTBOX - Potret: Maran_Waspada]`  
  **Maran:** *(Berdiri di balkon background, mengokang laras senjatanya dengan tatapan tajam)*  
  "Jangan bengong, Saka! Terus lari ke arah altar!! Gua bakal cover lu dari belakang!!"

---

#### **BAGIAN C: Gelombang 2 — Platforming Koridor Retak & Mid-Air Monster Vault (Floating Bubble)**

*(Saka bangkit berdiri dan berlari kencang menyusuri koridor pilar kuil kuno berlantai ubin batu. Lantai koridor telah hancur terkikis asam kronal membentuk tiga celah jurang menganga berurutan).*

* **[GAMEPLAY PLATFORMING — SPRINT & JUMP RETAKAN LANTAI]**
  * Saka melompati celah jurang pertama `[Space]`.
  * Saka melompati celah jurang kedua `[Space]`.

*(Saat Saka melompat di atas celah jurang ketiga yang paling lebar, mendadak dari dasar kegelapan jurang muncul **Utusan Kala 2** menyembul ke atas dengan cakar dan rahang menganga tepat di bawah jalur lompatan Saka!).*

* **[QUICK TIME EVENT (QTE 2) — MID-AIR VAULT / TRAMPOLINE STEP]**
  * **Prompt Layar:** `[TEKAN TOMBOL SPACE (MID-AIR STEP / INJAK MONSTER)]` *(Window Waktu: 1.2 Detik)*
  * **Eksekusi:** Di udara tanpa pijakan tanah, Saka menjejakkan kedua sol sepatunya keras-keras tepat ke wajah Utusan 2! Daya tolak tubuh monster melentingkan tubuh Saka melayang lebih jauh dan mendarat mulus di pelataran kaki tangga altar.

*(Hantaman kaki Saka membuat tubuh Utusan 2 terdorong menengadah ke atas dengan dada terbuka lebar. Dari balkon pilar di **Background Layer**, Maran langsung memanfaatkan sudut tembak bersih ini!).*

* `[SFX]`: *DORRR-KRRRRSHHH!! (Tembakan kinetik Maran menghantam telak inti kristal dada Utusan 2).*
* *(Utusan 2 meledak hancur di udara menjadi partikel kabut abu-abu dan jatuh lenyap ke dasar jurang asam!).*

* `[FLOATING BUBBLE - Maran]` *(Dari pilar latar belakang)*:  
  *"Pendaratan yang bagus, Saka! Tangga altar ada di depanmu, CEPAT NAIK!!"*

* `[FLOATING BUBBLE - Saka]` *(Mendarat di kaki tangga altar dan langsung berlari mendaki)*:  
  *"Gua hampir jadi santapan tadi... Sedikit lagi sampai ke puncak!!"*

---

#### **BAGIAN D: Gelombang 3 — Utusan Raksasa, Maran Foreground, & Kebangkitan Keris Pasupati**

*(Saka tiba di pelataran puncak altar punden berundak. Di depannya, Keris Pasupati tertancap di atas prasasti batu kuno).*

* `[SFX]`: *GROOOAAARRR-KABOOOMMM!!*  
  *(Utusan Kala 3—wujud raksasa bertanduk hitam dengan aura kosmik ungu pekat—melompat turun menghantam lantai tepat di hadapan Saka, memblokir altar dengan cakar raksasanya!).*

* *(Tepat sebelum cakar monster menghantam tubuh Saka, **Maran melompat turun dari background langsung ke LAYER FOREGROUND (sejajar dengan Saka)!**)*

* `[SFX]`: *CLANGGGGG!! (Laras senapan pipa Maran beradu keras menahan cakar raksasa monster).*
* *(Daya dorong monster membuat Maran terlempar ke samping dan membentur pilar kuil, meringis menahan hantaman).*

* `[FLOATING BUBBLE - Maran]` *(Meringis di lantai foreground)*:  
  *"Gua tahan monster ini... SAKA, CABUT SEKARANG JUGA!!"*

* **[INTERACTIVE MECHANIC — PULL THE SACRED WEAPON]**
  * **Prompt Layar:** `[TAHAN TOMBOL E SELAMA 3 DETIK (CABUT KERIS PASUPATI)]`
  * **Visual Feedback:** Meteran sinkronisasi energi emas menyala melingkari layar. Roda gigi *Chronos-Belt* di pinggang Saka berputar kencang menghasilkan medan cahaya resonansi murni.
  * **SFX:** *SHINNNGGGG... FOOOOSHHHH!! (Bilah luk Keris Pasupati terlepas dari batu, memancarkan kobaran api spiritual keemasan yang menerangi seisi kuil).*

* **[ACTION PROMPT — FIRST MELEE STRIKE]**
  * **Prompt Layar:** `[TEKAN TOMBOL J / KLIK KIRI (TEBASAN API PASUPATI)]`

* `[CUTSCENE / ANIMASI FINISHER SAKA]`  
  *(Saka melompat ke depan dengan mata bionik menyala penuh. Dalam satu ayunan tebasan horizontal, bilah api Keris Pasupati membelah tubuh Utusan Kala 3! Gelombang api spiritual suci melahap habis wujud monster kosmik tersebut hingga lenyap tak bersisa tanpa meninggalkan abu).*

* `[TEXTBOX - Potret: Saka_Awakened_Pasupati]`  
  **Saka:** *(Mengayunkan Keris Pasupati ke samping, bilahnya masih berkobar bara api mistis)*  
  "MENYINGKIR DARI JALANKU!!"

* **[UNLOCKED: SERANGAN MELEE KERIS PASUPATI (TOMBOL J / KLIK KIRI)]**  
  *Saka kini dapat melancarkan kombinasi serangan jarak dekat berbasis api spiritual Nusantara!*

---

#### **BAGIAN E: Epilog Act 1 — Gerbang Menuju Rimba Padjadjaran (Closing Vertical Slice)**

*(Suasana kuil kembali hening. Asap api spiritual perlahan memudar. Maran bangkit berdiri, menepuk debu di rompi taktisnya, lalu melangkah menghampiri Saka di layer depan).*

* `[TEXTBOX - Potret: Saka_Napas_Terengah]`  
  **Saka:** *(Memandangi bilah luk Keris Pasupati di genggamannya dengan takjub)*  
  "Keris ini... denyut energinya langsung bersinkronisasi sama sabuk peninggalan kakek gua..."

* `[TEXTBOX - Potret: Maran_Netral]`  
  **Maran:** *(Menatap bilah keris dengan senyum tipis penuh makna)*  
  "Keris Pasupati... ditempa dari serpihan meteorit purba bermuatan kronal murni ribuan tahun lalu. Hanya bilah pusaka Nusantara yang mampu memotong anomali ciptaan Sang Hyang Kala. Sekarang kau bukan lagi mangsa tanpa perlawanan, Saka."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menoleh ke arah pusaran portal waktu yang berputar di belakang altar)*  
  "Sinyal pelacak Tara ditarik masuk ke dalam portal ini... Gua harus nyusul dia sekarang juga."

* `[TEXTBOX - Potret: Maran_Waspada]`  
  **Maran:** *(Memeriksa modul Arkeo-Scanner di lengannya)*  
  "Fluktuasi temporal di balik portal itu mengarah ke tanah Jawa Barat... Abad ke-14, era Rimba Padjadjaran purba. Ingat peringatanku, Saka: setiap jejak yang kaurusak di masa lalu, kausalitas masa depan akan menagih bayarannya."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menggenggam liontin Tara erat di dadanya, lalu menghunus Keris Pasupati ke depan)*  
  "Berapa pun harganya... gua bakal bawa Tara pulang!"

*(Saka melangkah tegap menerobos masuk ke dalam pusaran portal waktu yang menyilaukan...)*

* `[SFX]`: *WHOOOOSHHH-SHINGGG!! (Layar memutih terang benderang).*

---

#### **[VERTICAL SLICE DEMO COMPLETE — TO BE CONTINUED]**

```
========================================================================================
                        KALA: SINGKAP GARIS WAKTU
                     --- VERTICAL SLICE DEMO CLEAR ---
========================================================================================

  [STATUS EKSPEDISI CHRONAL]
  • Era Selesai      : Astanapura 2150 (Prolog) ➔ Wanua Sriwijaya 682 M (Act 1)
  • Pusaka Diperoleh : [KERIS PASUPATI] (Serangan Melee Api Spiritual Terbuka)
  • Relasi Karakter  : Maran (The Watcher Anomaly) Terhubung
  • Destinasi Berikut: Rimba Padjadjaran & Megalopolis Majapahit (Abad ke-14 & 15)

  "Tidak semua yang hilang harus ditemukan kembali...
   Namun benang darah persaudaraan takkan pernah terputus oleh waktu."

                  >>> TO BE CONTINUED IN FULL GAME ACT 2 - FINAL <<<
========================================================================================
```

<div class="page-break"></div>

# ACT 2: RIMBA KAUSALITAS & SANG PENGAMAT
*(Setting: Rimba Padjadjaran Abad ke-14 & Megalopolis Majapahit Abad ke-15 ↔ Lab Geotermal & Kanal Maglev Astanapura 2150)*

---

### **RINGKASAN STRUKTUR ALUR ACT 2 (10 SCENE PENUH)**
```
STRUKTUR ALUR DRAMATIS ACT 2 (ROADMAP EKSPEDISI)
├── [PHASE 1: RIMBA PURBA PADJADJARAN (ABAD KE-14 ↔ LAB GEOTERMAL 2150)]
│   ├── SCENE 1: Lembah Curug Berbisik (Pendaratan, Cari Maran, Scavenging Herbal, & Tutorial Takedown)
│   ├── SCENE 2: Ngarai Kabut & Sisa Pondok Pemburu Kuno (Lore Teror Kala & Air-Drop Takedown)
│   ├── SCENE 3: Jurang Reaktor Geotermal 2150 & Puzzle Kausalitas Beringin Silika (Time-Switch Q & Jembatan Fosil)
│   ├── SCENE 4: Lab Terbengkalai Sektor 7 & Wasiat Kakek Wikana (Audio Log #087, Stimpack 2150, & Frekuensi 432 Hz)
│   └── SCENE 5: Punden Berundak, The Bootstrap Paradox, & Maran di Tebing (Branch 4 Dialog & Kapsul Kronal)
│
└── [PHASE 2: MEGALOPOLIS MAJAPAHIT (ABAD KE-15 ↔ KANAL MAGLEV 2150)]
    ├── SCENE 6: Gerbang Kota Bata Merah & Badai Singularitas Ungu (High-Octane Auto-Scroll Chase 4.5 m/s)
    ├── SCENE 7: Blind Leap Platforming di Kanal Air & Pipa Maglev 2150 (Time-Switch Q di Udara)
    ├── SCENE 8: Reruntuhan Bengkel Pandai Besi & Pusaka TOMBAK KUNTA [K] (Heavy Kinetic Burst)
    ├── SCENE 9: Menembus Barikade Gerbang Bendungan Raksasa dengan Kunta
    └── SCENE 10: Puncak Bendungan Kanal Melayang — Boss Fight TARA HALF-VESSEL (Branch 5 & Unlock Cakra Basunanda)
```

---

### **CATATAN PEMBUKA act2_01: Lembah Curug Berbisik & Ujian Tempur Rimba Padjadjaran (Abad ke-14)**
*(Layar fade in dari kilatan cahaya portal waktu. Kamera menyorot Saka yang jatuh tersungkur dari udara menembus kanopi pohon paku purba, mendarat di bebatuan kali yang licin dan berlumut di kaki tebing. Udara lembap berkabut tebal, gemuruh air terjun purba dan gerimis tipis hutan pegunungan terdengar jelas).*

* **SFX:** *BRUAAAKK... CRASHHH! (Suara tubuh menabrak ranting dan tanah basah).*

---

### **[act2_01] SCENE 1: Lembah Curug Berbisik — Rimba Padjadjaran (Abad ke-14)**

#### **BAGIAN A: Pendaratan Kasar, Syok Fisik, & Maran yang Ngilang**
*(Layar fade in perlahan dari kilatan cahaya putih portal waktu yang menyilaukan. Suara dengung frekuensi tinggi perlahan memudar, digantikan suara gemuruh air terjun purba dan gerimis hutan pegunungan).*

*(Kamera menyorot Saka yang jatuh menembus kanopi dedaunan paku raksasa, lalu terhempas menghantam bebatuan kali yang licin dan berlumut di kaki tebing. Ranting-ranting patah berserakan di sekitarnya).*

* **SFX:** *BRUAAAKK... CRASHHH! (Suara benturan tubuh membentur ranting dan tanah basah).*

* `[TEXTBOX - Potret: Saka_Napas_Terengah]`  
  **Saka:** *(Meringis kesakitan, terbatuk-batuk sambil memegangi rusuk kirinya, perlahan maksain diri buat duduk)*  
  "Aghh... uhuk! Sialan... Nafas gua serasa mau putus. Rasanya kayak dilempar dari atap Rusunawa Sektor Bawah tanpa tali pengaman... Badan gua remuk semua."

* `[TEXTBOX - Potret: Saka_Napas_Terengah]`  
  **Saka:** *(Nepuk-nepuk lumpur sama lumut basah di kain jarik Sriwijayanya, menggigil kedinginan karena bertelanjang dada di hawa pegunungan basah, lalu ngeraba roda gigi Chronos-Belt di pinggang)*  
  "Brrr... buset, dingin banget! Kemarin di pesisir Sriwijaya kain jarik Ki Pranata ini adem, tapi di hutan gunung basah begini, dada telanjang gua serasa mau beku! Roda gigi sabuk Kakek... syukurlah, modul konverternya masih muter stabil."

* `[TEXTBOX - Potret: Saka_Waspada]`  
  **Saka:** *(Nengok ke kiri-kanan, nyipitin mata nembus kabut rimba yang tebal)*  
  "Maran?! Di mana tuh orang tua aneh...? Ck, di kuil tadi gayanya sok misterius nyuruh gua cabut Pasupati dan bilang bakal mantau... Sekarang gua malah ditinggal mendarat sendirian di tengah hutan rimba antah-berantah."

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:**  
  "Tuh orang beneran kayak setan... cuma nongol kalau mau ngasih teka-teki atau peringatan nggak jelas. Nggak bisa diandelin. Dari awal emang ini urusan gua buat bawa Tara pulang."

*(Mata bionik kanan Saka mendengung pelan, lensa irisnya kedip-kedip biru-cyan terang ngelakuin kalibrasi otomatis).*

* **SFX:** *BZZZT-KLIK... WIP-WIP! (Arkeo-Optics UI Scanning & Calibration).*

* `[HUD OVERLAY - ARKEO-OPTICS SCAN LOG]`
  * [LOKASI: Hutan Pegunungan Jawa Barat Bagian Barat]
  * [ESTIMASI ERA: Abad ke-14 Masehi (Wilayah Kerajaan Sunda / Padjadjaran)]
  * [STATUS ATMOSFER: Hujan Tropis, Suhu 18.5°C, Kelembapan 94%]
  * [FLUKTUASI KRONAL: Residu Partikel Ungu Pekat Terdeteksi di Tebing Atas]

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Lensa bioniknya nge-zoom bercak lendir ungu berpendar yang netes di lumut batu kali)*  
  "Abad ke-14... dan suhu di sini dingin banget, beda jauh sama pantai Sriwijaya kemarin. Tapi yang lebih penting... residu lendir kronal ungu ini masih basah! Monster Kala baru aja nyeret Tara naik ke tebing atas."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Ngasap tetesan air hujan di mukanya yang kedinginan, tatapannya tajem)*  
  "Tunggu gua, Tara... Gua nggak bakal biarin monster keparat itu nyentuh lu lagi!"

---

#### **BAGIAN B: Eksplorasi Sepanjang Kali, Scavenging Herbal, & Pertolongan Pertama**
*(Pemain dapet kendali gerak penuh `A` / `D`. Saka jalan menyusuri tepian kali berarus deras di bawah cipratan air terjun raksasa, memeluk tubuhnya yang dingin).*

* `[TUTORIAL PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` untuk jalan. Tahan `Shift` buat lari cepat, dan tekan `Space` untuk lompatin batu kali.*

* `[FLOATING BUBBLE 1 - Berjalan 5 meter]`  
  **Saka:** *(Ngelirik bilah Keris Pasupati di pinggang kirinya)*  
  "Pasupati di pinggang gua... bilahnya masih anget berdenyut. Berasa kayak punya detak jantung sendiri yang nyambung ke sabuk Kakek."

* `[FLOATING BUBBLE 2 - Berjalan 12 meter]`  
  **Saka:** *(Nengadah ngeliat air terjun raksasa yang suaranya gemuruh kencang)*  
  "Gede banget curugnya... Seger juga udara pegunungan gini, tapi anginnya bener-bener nusuk kulit kalau cuma pake kain jarik gini."

*(Di deket ceruk batu kali yang basah, ada serumpun tanaman liar berumbi tebal yang nyala pendar emas anget).*

* `[ACTION PROMPT DI DUNIA]`  
  *Tekan `E` untuk meriksa dan mungut `[Rimpang Herbal Purba]`.*

*(Saka jongkok, nyabut umbi tanaman itu terus ngebelah getahnya pake kuku).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Ngehidu bau getah kuning emas di jarinya)*  
  "Tanaman rimpang liar... Aromanya persis kayak catatan botani kuno yang dulu pernah Kakek ceritain di bengkel."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:**  
  "Getahnya kaya mineral silika alami sama zat antiseptik. Kalau gua tumbuk darurat terus olesin ke luka memar di rusuk gua `[H]`, perihnya langsung adem dan pendarahannya mampet seketika."

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:**  
  "Di era 2150, Stimpack medis emang bisa langsung nutup hampir 80 persen luka robek dalam hitungan detik. Tapi di rimba antah-berantah abad ke-14 begini, tanaman liar kaya khasiat gini udah lebih dari cukup buat bertahan hidup."

* `[HUD PROMPT]`  
  *Tekan tombol `[H]` atau `[1]` untuk ngeracik dan make item medis pas darah Saka berkurang.*

---

#### **BAGIAN C: Celah Semak Ilalang, Danger Zone Tahan Napas, & Pasupati Silent Strike**
*(Saka jalan maju 15 meter ngelewatin celah tebing batu sempit. Di depan, jalan setapak ketutup semak ilalang setinggi dada).*

* **SFX:** *GRRRR... HSSSSHH! (Suara geraman berat monster bercampur desis uap anomali ungu).*

*(Saka langsung nundukin badan, nyusup masuk ke balik rimbunnya semak ilalang [E]).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Ngintip dari sela daun, nahan nafas sambil megang gagang Keris Pasupati)*  
  "Buset... monster itu!"

*(Kamera nge-zoom ke sosok **Sentinel Anomali Purba**: monster setinggi dua meter dengan cakar kristal runcing, zirah batu hitam legam, dan aura ungu yang ngebakar rumput di sekitarnya. Monster itu jalan patroli mondar-mandir dengan sorot pandang lampu kerucut di depannya).*

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Ngamatin gerakan monster dengan mata analitis)*  
  "Mereka bukan prajurit manusia Sriwijaya yang bisa gua ajak ngobrol atau gua tipu pake kain jarik. Ini monster bayangan murni ciptaan Kala... dan liat zirah lempeng kristal di dada depannya, tebel banget."

*(Lensa Arkeo-Optics nge-zoom ke arah tengkuk belakang monster, nampilin diagram titik lemah fraktal).*

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:**  
  "Sensor mata gua dapet titik lemahnya... Inti fraktal kristalnya ada di tengkuk belakang. Dan monster ini nggak punya kesadaran sama sekali di titik buta punggungnya."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:**  
  "Kalau gua tabrak langsung dari depan pake Pasupati `[J]`, gua butuh 4 sampe 6 tebasan keras buat ngejebol zirah depannya. Suaranya pasti bikin ribut hutan ini. Gua harus tunggu dia lengah di depan semak ini..."

---

*(Sentinel Anomali berjalan mendekat ke arah semak tempat Saka bersembunyi. Sorot mata kerucutnya berubah menjadi **KUNING**. Monster berhenti tepat beberapa jengkal di depan semak, mengendus udara dan mengamati goyangan daun).*

* **SFX:** *THUMP-THUMP... THUMP-THUMP... (BGM meredup drastis, suara detak jantung Saka mendentum kencang diiringi helaan nafas tertahan).*

* `[TUTORIAL PROMPT HUD — DANGER ZONE HEARTBEAT QTE]`  
  *Monster sedang menginspeksi semak persembunyian! Tekan `[E]` atau `[Klik Kiri]` tepat saat jarum berada di zona hijau (Sweet Spot) untuk menahan napas dan meredam detak jantung!*

*(Pemain menekan `[E]` tepat di zona hijau. Saka berhasil menahan napasnya rapat-rapat tanpa menimbulkan suara gesekan daun).*

* `[FLOATING BUBBLE - Saka]` *(Menahan napas di dalam semak)*:  
  *"Tahan... jangan gerak sedikit pun..."*

*(Monster menggeram pelan, mengira goyangan semak hanya hembusan angin rimba. Monster berbalik badan 180°, berjalan menjauh membelakangi semak! Titik buta di punggungnya kini terbuka lebar!).*

---

* `[ACTION PROMPT — PREPARE STEALTH TAKEDOWN]`  
  *Punggung musuh terbuka! Merayaplah keluar dari semak mendekati tengkuk musuh (radius 1.8 meter), lalu tekan `[E] PASUPATI SILENT STRIKE`!*

*(Pemain merayap keluar dari semak, mendekati punggung monster. Saka menekan `[E]`. Suasana mendadak hening total, waktu melambat menjadi 50% Slo-Mo. Di atas kepala monster muncul lingkaran hologram emas dengan jarum berputar cepat).*

* **SFX:** *TIK-TIK-TIK-TIK... (Jarum emas berputar 720°/detik).*

*(Pemain menekan `[E]` tepat pas jarum berada di dalam busur Sweet Spot emas).*

* **SFX:** *SHIIINGGG... FOOOSSHHH! (Dentang logam tajam disusul desis kobaran api spiritual).*

* `[CUTSCENE / ANIMASI FINISHER SAKA]`  
  *(Saka melesat seperti kilat! Dalam satu tusukan presisi, bilah api Keris Pasupati dihunjamkan pas ke inti kristal di tengkuk monster. Monster langsung beku, badannya retak memancarkan cahaya emas silau, lalu lenyap menguap menjadi abu partikel senyap yang terbawa angin rimba).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Narik kerisnya ke samping, bilahnya nyerap pendar energi kronal ungu yang tersisa)*  
  "Mantap... inti fraktalnya ancur total tanpa sempet teriak. Bilah Pasupati nyerap 20 persen sisa energi kronal mereka."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menatap jalan setapak nanjak ke arah ngarai kabut di atas)*  
  "Selama gua bisa pancing mereka balik badan dan nyergap dari titik buta, gua bisa bersihin hutan ini tanpa buang-buang tenaga. Sekarang... waktunya naik ke ngarai atas!"

---

### **[act2_02] SCENE 2: Ngarai Kabut & Sisa Pondok Pemburu Kuno (Abad ke-14)**

#### **BAGIAN A: Pendakian Tebing Terjal, 4 Lompatan Batu Cadas, & Panjat Akar Gantung**
*(Transisi layar: Saka keluar dari celah semak Scene 1. Jalan setapak tanah liat basah mulai menanjak terjal, diapit dinding tebing batu cadas berlumut. Suhu udara pegunungan turun makin dingin, kabut putih pekat menggulung turun dari puncak kanopi, membatasi jarak pandang hanya sekitar sepuluh meter).*

* `[FLOATING BUBBLE 1 - Mendaki 5 meter]`  
  **Saka:** *(Mengusap kedua lengannya yang merinding, hembusan napasnya mengepul putih)*  
  "Brrr... gila, nafas gua sampe ngeluarin uap. Angin gunungnya bener-bener nggak ada ampun buat orang yang cuma pake kain jarik tanpa baju kayak gua."

---

*(RINTANGAN PLATFORMING 1: Jalan setapak terputus oleh ngarai jurang sempit dengan arus kali deras berbatu di bawahnya. Terdapat deretan 4 bongkahan batu cadas bertingkat yang licin berlumut menyeberangi jurang).*

* `[TUTORIAL PROMPT DI LAYAR]`  
  *Gunakan `A` / `D` dan tekan `Space` secara berirama untuk melompati deretan 4 batu cadas licin menyeberangi jurang!*

*(Pemain melompat berurutan: Batu 1 ➔ Batu 2 ➔ Batu 3 ➔ Mendarat di Batu 4 seberang).*

* `[FLOATING BUBBLE 2 - Di tengah lompatan beruntun]`  
  **Saka:** *(Melompat lincah menjaga keseimbangan di atas batu licin)*  
  "Satu... dua... tiga... hap! Fiuh... hampir aja salah injek lumut basah!"

---

*(RINTANGAN TRAVERSAL 1: Tebing cadas setinggi 3 meter menghadang jalan. Di dindingnya menjuntai sulur akar gantung pohon paku purba).*

* `[TUTORIAL PROMPT HUD — CLIMBING VINES]`  
  *Dekati akar gantung, lalu tekan `Space` atau tombol `W` untuk memanjat sulur akar vertikal.*

* `[FLOATING BUBBLE 3 - Memanjat akar pertama]`  
  **Saka:** *(Meraih dan memanjat sulur akar pertama menuju undakan tengah)*  
  "Akar gantung ini alot dan kuat banget... Bagus, gua bisa pake buat manjat tebing cadas ini."

---

*(Saka tiba di undakan tengah. Di dinding batu cadas samping jalur, tampak bercak cairan anomali ungu menyala redup menempel di lumut).*

* `[ACTION PROMPT]`  
  *Tekan `F` untuk memindai bercak anomali di dinding tebing.*

* **SFX:** *BZZZT-BIP... (Arkeo-Optics Scan).*

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Lensa bioniknya memperbesar bekas goresan di sela lumut tebing)*  
  "Bercak kristal ungu lagi... dan liat ini, ada bekas gesekan kuku manusia di batu cadas. Tara pasti berusaha nahan dan berontak waktu diseret monster itu."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Mengepalkan tinjunya dengan rahang mengeras)*  
  "Tahan sebentar lagi, Dek... Kakak makin deket di belakangmu!"

---

*(RINTANGAN TRAVERSAL 2: Dinding tebing batu kapur vertikal setinggi 5 meter menuju teras atas saung. Sulur-sulur akar gantung beringin raksasa menjuntai lebat).*

* `[FLOATING BUBBLE 4 - Memanjat akar kedua]`  
  **Saka:** *(Menarik tubuhnya memanjat sulur akar kedua yang lebih tinggi)*  
  "Satu tebing lagi... Tara, tunggu gua!"

*(Pemain memanjat sulur akar sampai ke bibir tebing, lalu menarik tubuhnya naik ke atas teras tebing yang berkabut pekat).*

* `[FLOATING BUBBLE 5 - Tiba di teras tebing atas]`  
  **Saka:** *(Berdiri mengatur napas, menyeka tempias embun di dahinya)*  
  "Hah... hah... nyampe juga di teras atas. Kabut di sini tebel banget... tapi itu di depan kayak ada bangunan panggung?"

---

#### **BAGIAN B: Saung Panggung Pemburu, Rompi Kulit, & Lore Kulit Kayu**
*(Saka tiba di teras tebing yang agak rata. Di tepi jurang kabut, berdiri sebuah saung panggung kayu dan bambu beratap ijuk hitam khas pemburu Sunda Kuno abad ke-14 yang telah porak-poranda. Pintu bambunya terhempas rusak ke dalam, anak tangganya basah berlumut, dan tungku perapian di teras tampak padam terinjak jejak cakar ungu).*

* `[FLOATING BUBBLE 1 - Mendekati saung]`  
  **Saka:** *(Menaiki 3 anak tangga bambu sambil merapatkan kedua lengannya yang kedinginan)*  
  "Ada pondok pemburu di bibir jurang... Pintunya jebol dari luar. Tungku apinya masih nyisa kepulan arang anget... Belum lama ditinggalin ini."

*(Saka melangkah masuk ke dalam saung. Di lantai bambu berserakan gentong tembikar pecah dan anyaman jerami. Di dinding bambu yang masih tegak, tergantung selembar rompi tebal dari kulit kijang rimba dengan lapisan bulu halus di bagian dalam dan ikatan tali rotan di sampingnya).*

* `[ACTION PROMPT DI DUNIA]`  
  *Tekan `E` untuk mengambil dan mengenakan `[Rompi Kulit Pemburu Padjadjaran]`.*

*(Saka menyambar rompi kulit tersebut, mengenakannya di atas tubuhnya yang bertelanjang dada, lalu mengencangkan kembali gesper sabuk Chronos-Belt di luarnya).*

* **SFX:** *SHT-SHT... KLIK-KLAK! (Suara gesekan kulit tebal dipasang, disusul bunyi roda gigi sabuk dikunci).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Menghembuskan napas panjang yang hangat, menepuk dada rompinya)*  
  "Hahh... gila, langsung berasa anget. Lapisan bulu di dalemnya pas banget buat nahan angin gunung sialan ini. Bahannya juga liat dan tebel... nggak bakal gampang robek kalau kena duri tebing pas manjat nanti."

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Memeriksa sabuk Chronos-Belt di pinggangnya dan mencoba meregangkan kedua pundaknya)*  
  "Chronos-Belt juga masih ngunci stabil di luar rompi. Nggak ganggu gerakan ayunan tangan. Bagus... sekarang badan gua udah jauh lebih siap."

---

*(Pemain berjalan ke sudut samping tungku perapian. Di atas balai bambu terdapat tempurung kelapa berisi serbuk rimpang obat yang sudah dikeringkan).*

* `[ACTION PROMPT]`  
  *Tekan `E` untuk mengambil `[Rimpang Herbal Purba]` (+1 stok medkit; kapasitas tetap 3).*

* `[FLOATING BUBBLE 2 - Memungut herbal]`  
  **Saka:** *(Mengantongi serbuk herbal ke saku samping rompi kulitnya)*  
  "Serbuk rimpang obat yang udah ditumbuk halus... Lumayan buat nambah cadangan darurat di kantong rompi. Gua nggak tahu bakal ketemu monster sekuat apa lagi di atas sana."

---

*(Pemain melangkah ke tengah ruangan, mendekati meja kayu bundar kasar. Di atas meja tersebut, terdapat selembar gulungan kulit kayu daluang tua yang tertancap belati tembaga berkarat ke papan meja).*

* `[ACTION PROMPT]`  
  *Tekan `F` untuk memindai Naskah Kulit Kayu Daluang dengan Arkeo-Optics.*

* **SFX:** *BZZZT-BIP... WHIRRR! (Lensa bionik Arkeo-Optics memindai serat getah tinta dan memunculkan proyeksi aksara Sunda Buhun yang diterjemahkan ke HUD biru).*

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Mata bioniknya menerjemahkan baris demi baris goresan tinta getah alami)*  
  "Catatan harian pemburu lokal... *'Bulan Purnama Katiga... Bayangan hitam tanpa wajah merayap turun dari celah langit puncak kabut. Mereka tidak memburu hewan rimba, tidak pula menjarah lumbung ternak warga...'*"

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Membaca lanjutan kalimat dengan tatapan semakin tegang)*  
  "*'Makhluk-makhluk itu mencari mereka yang berdarah suci—keturunan para Empu penjaga punden berundak di puncak lereng... Punden atas telah luluh lantak, anak-anak mereka direnggut ke dalam kabut kehampaan. Kami warga lereng terpaksa mengungsi ke hilir sebelum waktu kami sendiri terhapus...'* "

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Tangannya spontan meraba liontin Tara di balik lipatan rompinya, napasnya memburu)*  
  "Keturunan Empu penjaga punden... Astaga... Dulu waktu gua masih kecil, Kakek selalu cerita kalau silsilah keluarga Wikana itu keturunan pandai besi sakti dan pembaca bintang di tanah Jawa Barat."

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Mengusap wajahnya yang tegang)*  
  "Dulu gua selalu ngira itu cuma dongeng pengantar tidur biar gua rajin belajar mekanik... Tapi ternyata omongan Kakek beneran nyata. Darah penjaga yang ada di tubuh Tara... itu alasan kenapa Kala ngincer dia di jembatan rusunawa!"

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Mengepalkan tinju kanannya sekuat tenaga hingga buku-buku jarinya memutih, rahangnya mengeras)*  
  "Kala bukan cuma nyulik anak orang sembarangan... Dia butuh kemurnian darah Tara buat dijadiin wadah tumbal spiritual biar bisa bangkit seutuhnya di era modern. Brengsek... gua nggak bakal biarin monster itu nyentuh sehelai pun rambut adik gua!"

* `[FLOATING BUBBLE 3 - Melangkah ke pintu belakang]`  
  **Saka:** *(Menghunus Keris Pasupati yang berpendar api jingga redup)*  
  "Punden atas ada di balik jurang beringin ini... Gua harus cepet sebelum ritual mereka selesai!"

---

#### **BAGIAN C: Pelataran Semak Berbatu, Multi-Beat QTE, & Dual Sentinel Stealth**
*(Saka melangkah keluar dari pintu belakang saung pemburu. Di depannya terbentang pelataran tebing berbatu yang dihiasi beberapa rumpun semak ilalang tebal dan bongkahan batu cadas. Tampak **2 Sentinel Anomali** sedang berpatroli silang dengan sorot mata kerucut hijau saling mengawasi celah).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Merunduk rendah di balik dinding saung, lensa matanya menganalisis lintasan patroli)*  
  "Ada dua monster bayangan sekaligus di pelataran ini... Yang satu mondar-mandir di celah semak depan, yang satu lagi muterin batu cadas di tengah."

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Mengencangkan genggaman Keris Pasupati)*  
  "Kalau gua salah langkah atau bikin ribut pas ngabisin yang pertama, monster kedua pasti langsung denger dan ngeroyok barengan. Gua harus beresin mereka satu per satu lewat semak ilalang itu."

---

*(Pemain merunduk mendekati rumpun semak pertama dan menekan `[E]`).*

* `[ACTION PROMPT]`  
  *Tekan `[E]` untuk bersembunyi di rumpun semak pertama.*

*(Saka bersembunyi di semak. Sentinel 1 mendadak berbelok tajam ke arah semak Saka! Monster itu berhenti tepat beberapa jengkal di depan wajah Saka, matanya menyala **KUNING**, mendengus mengendus dedaunan).*

* **SFX:** *THUMP-THUMP... THUMP-THUMP... (BGM hening total, detak jantung Saka mendentum kencang).*

* `[TUTORIAL PROMPT HUD — MULTI-BEAT DANGER ZONE QTE]`  
  *Monster sedang mengendus semak! Tekan `[E]` atau `[Klik Kiri]` tepat di Sweet Spot sebanyak **3 KALI BERTURUT-TURUT** untuk menahan napas sampai monster pergi!*

*(Pemain menekan tombol secara berirama: Beat 1 Sukses! ➔ Beat 2 Sukses! ➔ Beat 3 Sukses!).*

* `[FLOATING BUBBLE 1 - Di dalam semak]`  
  **Saka:** *(Napas tertahan rapat, bibirnya terkatup kaku)*  
  *"Satu... dua... tiga... Tahan... jangan sampai detak jantung lu kedengeran..."*

*(Sentinel 1 mendengus pelan, lalu berbalik badan 180° melangkah menjauhi semak).*

* `[ACTION PROMPT]`  
  *Punggung Sentinel 1 terbuka! Merayap keluar dan tekan `[E] PASUPATI SILENT STRIKE`!*

*(Pemain merayap keluar, menekan `[E]` pas di zona Sweet Spot Radial Ring).*

* **SFX:** *SHIIINGGG! FOOOSSHHH! (Finisher 1-Hit Kill: Keris Pasupati menghujam tengkuk Sentinel 1, tubuh monster lumat senyap menjadi abu partikel).*

* `[FLOATING BUBBLE 2 - Takedown pertama]`  
  **Saka:** *(Merapatkan tubuhnya ke balik batu cadas)*  
  *"Satu tumbang tanpa suara... Tinggal satu lagi yang di dekat batu cadas tengah."*

---

*(Pemain mengamati rute patroli Sentinel 2. Saat Sentinel 2 berbalik membelakangi jalur, pemain merayap melintasi celah terbuka menuju rumpun semak kedua, mendekati punggung Sentinel 2).*

* `[ACTION PROMPT]`  
  *Dekati punggung Sentinel 2, lalu tekan `[E] PASUPATI SILENT STRIKE`!*

*(Pemain mengeksekusi Silent Strike kedua dengan sukses).*

* **SFX:** *SHIIINGGG-KZZZT! (Sentinel 2 hancur senyap jadi abu).*

---

#### **[JALUR GAGAL / MELEE COMBAT BRAWL (JIKA SALAH SATU QTE MISS)]**
*(Jika pemain gagal di salah satu QTE atau menabrak monster).*

* **SFX:** *GRAAAAUUURRR! (Monster menjerit melengking, sorot matanya menyala **MERAH** tanda alarm!).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Meringis terkena sabetan cakar pertama, -1 Hati)*  
  "Sialan, ketahuan! Monster yang satunya ikut nyerang!"

* `[COMBAT PROMPT HUD]`  
  *ALARM TERPICU! 2 Monster menyerang bersamaan! Gunakan kombo `[J]` (4–6 Hit) dan meluncur `[Ctrl]` untuk menghindari kepungan cakar!*

*(Pemain bertarung sengit: menebas kombo api Pasupati `[J]`, meluncur menghindar saat kedua monster menyerang berbarengan, hingga kedua monster meledak tumbang).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Napas terengah-engah, menyeka peluh di dahinya)*  
  "Hah... hah... dikeroyok dua monster sekaligus bener-bener nguras tenaga. Untung rompi kulit ini nahan sebagian sabetan cakar mereka."

---

* `[FLOATING BUBBLE 3 - Menatap teras beringin di depan]`  
  **Saka:** *(Menyimpan keris di pinggang, melangkah maju)*  
  "Area semak ini udah beres. Sekarang... mari kita naik ke teras pohon beringin raksasa di atas."

---

#### **BAGIAN D: Pohon Beringin Raksasa & Eksekusi Air-Drop Silent Strike**
*(Saka melangkah melewati celah batu cadas, tiba di pelataran teras atas yang luas. Di tepi jurang berkabut berdiri sebatang **Pohon Beringin Purba Raksasa** yang megah. Cabang-cabang dahannya yang tebal membentang horizontal empat meter di atas jalan, dengan sulur-sulur akar gantung menjuntai lebat ke tanah. Di bawah dahan pohon, tampak **1 Sentinel Anomali Berzirah Berat** sedang mondar-mandir menjaga celah jalan keluar).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Merunduk di balik batu pembatas, lensa Arkeo-Optics meneliti pelataran)*  
  "Tanah di depan sini rata dan bersih... Nggak ada semak ilalang sama sekali buat sembunyi. Kalau gua nekat jalan di bawah, monster itu pasti langsung liat gua dari jarak sepuluh meter."

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Mendongak ke atas, mengamati dahan beringin yang membentang di atas jalur patroli)*  
  "Tapi liat dahan beringin raksasa di atas itu... Posisinya pas banget melintang di atas kepala monster. Gua bisa manjat sulur akar gantung di samping ini dan ambil posisi sergap dari udara!"

---

*(Pemain mendekati sulur akar gantung di sisi kiri, lalu menekan `W` atau `Space` untuk memanjat ke atas dahan pohon beringin).*

* `[ACTION PROMPT]`  
  *Tekan `W` / `Space` untuk memanjat sulur akar gantung menuju dahan pohon beringin.*

*(Saka memanjat sulur akar dengan tangkas, lalu menarik tubuhnya naik dan merayap berjalan di atas dahan kayu tebal).*

* `[FLOATING BUBBLE 1 - Berada di atas dahan pohon]`  
  **Saka:** *(Mengintip ke bawah, mengunci posisi tengkuk monster)*  
  *"Posisi gua tepat di atas kepalanya... Tinggal tunggu dia jalan pas di bawah dahan ini."*

---

*(Sentinel Anomali berjalan pelan tepat melintas di bawah dahan pohon tempat Saka berpijak).*

* `[TUTORIAL PROMPT HUD — AIR-DROP SILENT STRIKE]`  
  *Musuh tepat di bawahmu! Lompat dan tekan `[E] AIR-DROP STRIKE`! Momentum gravitasi membuat zona Sweet Spot 1.5x lebih lebar!*

---

#### **[PERCABANGAN AKSI 1: JALUR SUKSES AIR-DROP TAKEDOWN]**
*(Pemain melompat dari dahan dan menekan `[E]` tepat di Sweet Spot emas).*

* **SFX:** *SWOOOSH... TIK-TIK-TIK... SHIIINGGG-FOOOSSHHH! (Suara desau angin menukik disusul dentang tusukan fatal Pasupati).*

* `[CUTSCENE / ANIMASI FINISHER SAKA]`  
  *(Saka menukik jatuh seperti elang pemangsa! Bilah api Keris Pasupati dihunjamkan sekuat tenaga tepat ke inti kristal tengkuk monster. Beban gravitasi jatuh menghancurkan zirah monster seketika! Monster meledak senyap menjadi abu emas, sementara Saka berguling mendarat mulus di tanah tanpa menimbulkan suara).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Bangkit berdiri dari posisi berlutut, mengibaskan abu dari rompi kulitnya)*  
  "Mendarat mulus... Sergapan dari atas bener-bener efektif kalau tanahnya nggak punya tempat sembunyi."

---

#### **[PERCABANGAN AKSI 2: JALUR GAGAL / MISS]**
*(Jika pemain meleset saat menekan Sweet Spot di udara).*

* **SFX:** *DUGG-CLANGGG! (Pendaratan tidak seimbang, ujung keris membentur bahu keras monster!).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Terpental jatuh ke tanah, terkena sabetan cakar -1 Hati)*  
  "Argh! Meleset... Pendaratan gua nggak pas!"

* `[COMBAT PROMPT HUD]`  
  *Duel di bibir jurang! Gunakan kombo tebasan pedang `[J]` (4–6 Hit) dan hindari dorongan cakar monster sebelum terhempas ke jurang!*

*(Pemain bertarung sengit di tepi tebing: mengayunkan kombo pedang Pasupati `[J]` hingga monster terhempas hancur ke dasar jurang).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Mengatur napasnya yang tersengal di bibir tebing)*  
  "Hah... hampir aja gua kedorong jatuh ke kali bawah. Untung masih sempet nebas balik."

---

#### **[PENUTUP SCENE 2: MENUJU JURANG HULU CURUG]**
*(Setelah monster dieliminasi, Saka melangkah ke ujung celah tebing. Di depan terbentang jurang hulu curug yang curam dengan air terjun deras bergemuruh. Di seberang jurang tampak situs batu punden berundak kuno berselimut kabut).*

* **SFX:** *BZZZT-KLIK... WHIRRRR! (Lampu LED sabuk Chronos-Belt Saka menyala pendar biru cyan stabil).*

* `[HUD OVERLAY - ARKEO-OPTICS SCANNER]`  
  *`[DETEKSI TEMPORAL]: Zona Resonansi Waktu Terdeteksi!`*  
  *`[HISTORICAL ANCHOR ACTIVE]: Titik Lompatan Temporal Siap Digunakan [Q].`*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Memegang sabuk Chronos-Belt di pinggangnya, menatap jurang yang memisahkan jalurnya)*  
  "Jalan setapaknya putus kena jurang air terjun... tapi sabuk Kakek mulai nyala biru terang. Ada titik resonansi waktu di sini."

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Tatapannya tajam penuh keyakinan)*  
  "Di era 2150, tebing ini pasti udah jadi fasilitas geotermal yang Kakek teliti. Waktunya lompat ke masa depan dan cari jalan nyebrang... Tara, Kakak dateng!"

*(Layar bergetar lembut memancarkan partikel prisma waktu, siap bertransisi ke **Scene 3: Jurang Reaktor Geotermal 2150 & Puzzle Kausalitas Beringin**).*

---

### **[act2_03] SCENE 3: Jurang Reaktor Geotermal 2150 & Puzzle Kausalitas Beringin Silika**
*(Saka tiba di celah ngarai curam di hulu curug. Di hadapannya membentang jurang tebing yang terputus total. Di seberang jurang, tampak tangga batu menuju pelataran Punden Berundak di puncak bukit).*

---

#### **BAGIAN A: Jurang Reaktor Plasma 2150 & Analisis Kausalitas Arkeo-Optics**
*(Transisi layar: Saka berdiri di bibir tebing hulu curug Abad ke-14 yang terputus oleh jurang ngarai curam. Di pinggangnya, indikator LED sabuk Chronos-Belt berdenyut pendar biru cyan stabil menandakan titik jangkar waktu / Historical Anchor aktif).*

* `[TUTORIAL PROMPT HUD]`  
  *Zona Resonansi Waktu Aktif! Tekan tombol `[Q]` untuk melakukan **Time-Switch** melompat ke tahun 2150!*

*(Pemain menekan `[Q]`. Saka menarik tuas Chronos-Belt di pinggangnya).*

* **SFX:** *WUB-WUB-WUB... KZZZZT-ZWAAASH! (Gelombang distorsi kroma biru-emas membungkus layar. Hutan tropis berkabut Abad 14 berganti instan dalam 0.3 detik menjadi lorong baja industri futuristik Astanapura 2150 yang terbengkalai).*

---

*(Layar stabil: Hawa dingin hutan pegunungan berganti seketika menjadi hawa panas berminyak, bau ozon terbakar, dan desis uap pipa hidrolik bertekanan tinggi. Lampu darurat neon kuning-oranye berkedip lambat di langit-langit koridor baja berkarat).*

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Menyipitkan mata menahan sengatan hawa panas yang menyergap wajahnya)*  
  "Whoaa... Hawa dingin gunung langsung lenyap, ganti jadi bau oli gosong sama uap kimia panas. Selamat datang kembali di era 2150..."

* `[TEXTBOX - Potret: Saka_Rompi_Pemburu]`  
  **Saka:** *(Melirik bayangan dirinya di pelat dinding baja yang berkarat sambil tersenyum kecut)*  
  "Lucu juga ngeliat diri gua sendiri... Mekanik 2150 yang sekarang berdiri di tengah lorong pabrik geotermal pake rompi kulit rusa rimba abad ke-14."

---

*(Saka melangkah maju 3 meter ke tepi lantai jeruji besi yang telah amblas runtuh. Kamera menyorot ke bawah: Di dasar jurang mengalir **Lantai Plasma Reaktor Geotermal** bertegangan tinggi dengan sambaran lidah listrik ungu-kebiruan yang mendengung liar).*

* **SFX:** *BZZZT-CRACKLEEE... BZZZT! (Suara dengung busur plasma listrik tegangan tinggi).*

*(Saka mengambil sebuah baut baja berkarat dari lantai, lalu melemparkannya ke dasar jurang).*

* **SFX:** *FOOOOSH-KZZT! (Baut baja tebal langsung meledak menguap menjadi serbuk abu biru dalam sekejap mata).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Mata bionik berkedip merah waspada, menelan ludah)*  
  "Gila... baut baja setebal jempol langsung nguap jadi debu dalam seperseratus detik. Di era 2150 ngarai ini dijadiin pembuangan plasma turbin reaktor geotermal. Sekali kaki gua nyentuh lantai bawah, nggak bakal ada yang tersisa dari tubuh gua."

---

*(Kamera menyorot ke dinding tebing seberang di lantai dua: Tampak pintu baja berpelat tebal dengan lampu kode digital bertuliskan **`[SEKTOR 7: LAB RISET PRIBADI DR. RADEN WIKANA]`**, namun jembatan besi gantry dan tangga menuju ke sana telah putus total dan amblas ke jurang plasma).*

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Lensa bioniknya memperbesar papan nama pintu di seberang)*  
  "Itu lab riset peninggalan Kakek di lantai dua... Waktu gua masih umur sepuluh tahun, Kakek sering bawa gua ke sini sebelum fasilitas geotermal ini ditutup korporat."

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Mengepalkan tangannya menatap jurang yang memisahkan jalurnya)*  
  "Modul frekuensi resonansi buat ngebuka punden altar pasti tersimpan di terminal lab Kakek. Masalahnya, jembatan sama tangga besinya udah putus total ke dasar plasma. Nggak ada platform yang bisa gua loncatin."

---

*(Pemain menekan `[F]` untuk memindai area jurang dan dinding tebing seberang).*

* `[ACTION PROMPT]`  
  *Tekan `[F]` untuk mengaktifkan pemindai Arkeo-Optics dan analisa objek di dinding tebing seberang!*

* **SFX:** *BZZZT-BIP... WHIRRR! (Lensa Arkeo-Optics menyorot sebuah tunggul kayu raksasa yang mati kering lapuk dan menghitam di dinding tebing dekat lab).*

* `[HUD OVERLAY - ARKEO-OPTICS SIMULATOR]`  
  *`[OBJEK TERDETEKSI]: Fosil Tunggul Pohon Beringin Purba (Mati Kering & Rapuh).`*  
  *`[ANALISIS STRATIGRAFI]: Pohon mati kekeringan pada pertengahan Abad ke-14 akibat aliran air curug belerang tersumbat longsoran batu cadas.`*  
  *`[SIMULASI KAUSALITAS LINTAS WAKTU]: Jika bibir tebing di Abad ke-14 dialiri air curug panas kaya mineral silika vulkanik, selama 700 tahun struktur seluler akar beringin akan menyerap cairan silika terus-menerus dan mengalami PETRIFIKASI KRISTAL SILIKA MURNI (Isolator Listrik Alami 100%).`*  
  *`[HASIL ESTIMASI REALITAS 2150]: Akar fosil silika tumbuh raksasa menjembatani jurang plasma listrik dengan aman!`*

---

* `[TEXTBOX - Potret: Saka_Serius_Tekad]`  
  **Saka:** *(Mata bioniknya berbinar saat membaca grafik simulasi kuantum)*  
  "Tunggul kayu mati itu... Dulu waktu Abad 14, bibit beringin ini mati kekeringan gara-gara air curugnya tersumbat batu longsor."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Tersenyum tipis teringat wejangan Kakeknya di masa lalu)*  
  "Gua inget kata-kata Kakek dulu... *'Saka, alam dan sains itu bukan musuh. Air mineral dari perut bumi vulkanik mengandung silika alami yang bisa jadi isolator listrik terbaik kalau mengendap ratusan tahun.'*"

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menepuk sabuk Chronos-Belt di pinggangnya dengan penuh keyakinan)*  
  "Kalau di Abad 14 gua ancurin batu longsornya dan alirin air curug silika ke bibit beringin, 700 tahun kemudian akar beringin ini bakal bermutasi jadi **Jembatan Fosil Kristal Silika** yang kebal sengatan listrik di era 2150!"

* `[FLOATING BUBBLE 1 - Memegang tuas sabuk]`  
  **Saka:** *(Menarik tuas Chronos-Belt)*  
  "Rencananya udah matang. Waktunya lompat balik ke Abad 14 `[Q]` dan belah batu longsor penyumbat curug pake Pasupati!"

---

#### **BAGIAN B: Membuka Aliran Curug di Abad ke-14**

*(Pemain menekan `[Q]` kembali ke Abad 14. Saka mendaki ke tebing atas, melewati dua patroli musuh dengan stealth takedown).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Tiba di hulu sungai, melihat bongkahan batu besar menyumbat aliran air terjun menuju bibit beringin purba)*  
  "Bongkahan batu longsor ini menyumbat air mineral curug! Kalau kubelah batu ini dengan Pasupati, airnya bakal mengairi bibit pohon beringin di tebing seberang!"

* `[ACTION PROMPT — SERANG BONGKAHAN BATU DENGAN TOMBOL J]`

*(Saka menebas bongkahan batu dengan kombo 2-Hit Pasupati. Batu pecah berkeping-keping. Aliran air terjun deras mengalir membasahi akar bibit pohon beringin raksasa).*

* **SFX:** *ROOOAAAR-SPLASHHH! (Gemuruh air curug mengalir deras menuruni jurang).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** "Berhasil! Bibit beringinnya mulai menyerap air mineral silika. Sekarang... kita lihat hasil pertumbuhannya 700 tahun kemudian!"

---

#### **BAGIAN C: 700 Tahun Fosil Silika (2150) & Penyeberangan Reaktor**

*(Pemain menekan `[Q]` kembali ke era 2150).*

* **SFX:** *SHWWWOOOOSHHH... TINGGG!*

*(Pohon beringin yang diairi di abad ke-14 kini telah berubah menjadi **Akar Jembatan Fosil Berkristal Silika** raksasa yang kokoh melintang di atas reaktor plasma listrik! Kristal silika hijau kebiruan memantulkan pendar indah tanpa menghantarkan arus listrik).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Berjalan mantap melintasi jembatan akar fosil silika)*  
  "Sempurna! Fosil silika sama sekali nggak menghantarkan arus plasma. Kausalitas waktu bekerja persis seperti perhitungan kakek!"

*(Saka menyeberangi jembatan fosil, lalu melompat melakukan Wall-Jump menaiki pipa vertikal menuju pintu masuk lantai dua lab geotermal tua 2150).*

---

### **[act2_04] SCENE 4: Lab Terbengkalai Sektor 7 & Wasiat Kakek Wikana (Tahun 2150)**
*(Saka mendorong pintu besi berkarat lab geotermal lantai 2. Ruangan remang-remang berdebu dipenuhi rak perkakas, mikroskop bionik tua, papan sirkuit terbakar, dan meja solder yang susunannya persis seperti kamar Rusunawa Saka).*

---

#### **BAGIAN A: Eksplorasi Ruang Kerja Kakek & Looting Medis**

* `[FLOATING BUBBLE 1 - Melangkah masuk ke lab]`  
  **Saka:** *(Menatap sekeliling dengan tatapan haru)*  
  "Meja solder ini... bau timah dan fluks... Kakek pernah menghabiskan waktu bertahun-tahun di ruangan ini sebelum mendirikan bengkel di Rusunawa."

*(Pemain dapat menekan `E` pada kotak P3K dinding pabrik untuk mengambil **`[Stimpack Medis 2150]`**).*

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Mengantongi tabung injektor Stimpack ke saku taktisnya)*  
  "Stimpack darurat buatan pabrik... Ini bisa menyembuhkan luka berat instan kalau situasiku genting nanti."

---

#### **BAGIAN B: Rekaman Audio Log #087 & Pengunduhan Frekuensi 432 Hz**

*(Saka mendekati meja komputer utama. Di sana menyala monitor tabung monokrom berdebu).*

* `[ACTION PROMPT — TEKAN E UNTUK MENGAKSES TERMINAL LAB KAKEK]`

*(Saka menekan tuts keyboard berdebu. Monitor tabung berkedip, hologram audio menyala memancarkan pendar oranye hangat).*

* **SFX:** *KREK... BZZT... (Suara derit kursi laboratorium tua. Terdengar helaan napas berat dan suara batuk tersengal-sengal).*

* `[AUDIO LOG PLAYBACK — DR. RADEN WIKANA (Tahun 2148)]`  
  **Kakek (Suara Bergetar & Pilu):**  
  *"Saka... jika kau mendengar rekaman ini di masa depan, berarti anomali itu sudah menelan segalanya. Dan berarti... Kakek sudah gagal melindungi adikmu, Tara."*

* `[TEXTBOX - Potret: Saka_Hancur]`  
  **Saka:** *(Terdiam mematung, menatap pendar hologram kakeknya dengan mata berkaca-kaca)*  
  "K-Kakek..."

* `[AUDIO LOG PLAYBACK — DR. RADEN WIKANA]`  
  **Kakek:**  
  *"Seumur hidup, Kakek membedah catatan kuno keluarga kita, mengira Kakek-lah yang merakit teknologi Chronos-Belt ini dari nol. Tapi semakin dalam Kakek meneliti prasasti Padjadjaran, semakin Kakek sadar... ada bayangan seseorang dari masa depan yang membimbing tangan leluhur kita sejak tujuh abad lalu.*  
  *Saka... orang itu adalah kau sendiri, Nak.*  
  *Jangan benci takdir ini. Lindungi Tara. Jangan biarkan Parasit Kala merebut senyuman terakhir adikmu. Kakek meninggalkan modul resonansi 432 Hertz di terminal ini. Gunakan itu untuk membuka altar beringin di Padjadjaran. Pergilah... jadilah fajar bagi garis waktu kita."*

* `[SFX]`: *BEEP-BEEP... DOWNLOAD COMPLETE! (File `Chronos_Resonance_432Hz.dat` terunduh ke modul sabuk Saka).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Mengusap sudut matanya, mengepalkan tangan kanannya dengan erat)*  
  "Aku mengerti sekarang, Kek... Amanah ini... nggak akan kusia-siakan. Aku akan bawa Tara pulang!"

---

### **[act2_05] SCENE 5: Punden Berundak, The Bootstrap Paradox, & Konfrontasi Maran**
*(Pemain menekan `[Q]` kembali ke Abad 14. Saka menyeberangi jembatan fosil dan tiba di depan pintu batu Punden Berundak yang terkunci lempeng tembaga purba).*

---

#### **BAGIAN A: Resonansi Gelombang 432 Hz**

* `[ACTION PROMPT — TEKAN E UNTUK MENGAKTIFKAN RESONANSI 432 HZ]`

*(Sabuk Saka berputar memancarkan frekuensi sonik harmonik 432 Hz. Lempeng tembaga di pintu altar bergetar lembut memancarkan cahaya keemasan).*

* **SFX:** *HUMMMMM... KLIK-KLAK-KRAAAK! (Mekanisme pintu batu kuno bergeser terbuka).*

---

#### **BAGIAN B: Flashback Sinematik Sang Empu Padjadjaran (The Bootstrap Paradox)**

*(Saka melangkah masuk ke dalam bilik punden, mengaktifkan pemindai Arkeo-Optics `[F]` pada meja prasasti tengah).*

* **SFX:** *SHRRR-WSHHHH! (Lensa bionik Saka beresonansi kencang. Layar mengalami distorsi visual sepia-gold / Temporal Echo Flashback).*

* `[CUTSCENE SINEMATIK: GEMA WAKTU EMPU PURBA]`  
  *(Kamera bergerak memutar menyorot siluet seorang Empu sepuh berpakaian adat Sunda kuno Abad ke-14 yang tengah memahat lempeng tembaga di bilik ini.*  
  *Tiba-tiba, sang Empu mendongak terperanjat. Di hadapannya, celah ruang dan waktu terbuka transparan—memperlihatkan sosok pemuda berjaket modern dengan roda gigi sabuk bercahaya di pinggangnya: **Saka sendiri!**.*  
  *Sang Empu terpaku takjub melihat mekanisme roda gigi kronal di pinggang Saka. Dengan tangan bergetar penuh ilham suci, sang Empu buru-buru menggoreskan sketsa blueprint sabuk tersebut ke atas gulungan daun lontar keluarga Wikana—lontar yang 700 tahun kemudian ditemukan oleh Kakek Saka di era 2150!).*

*(Layar kembali normal. Saka mundur selangkah sambil memegangi sabuk di pinggangnya, napasnya memburu cepat).*

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:**  
  "T-Tunggu dulu... Blueprint yang dipelajari Kakek di masa depan... digambar oleh leluhurku karena beliau melihat sabuk yang kupakai saat ini?! Jadi... siapa yang sebenarnya pertama kali menciptakan sabuk waktu ini?!"

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:**  
  "Awal dan akhir... masa lalu dan masa depan saling melahirkan satu sama lain... Ini lingkaran kausalitas tertutup!"

---

#### **BAGIAN C: Konfrontasi Maran di Puncak Tebing Batu Kapur (Branch 4)**

*(Saka melangkah keluar dari bilik punden menuju puncak tebing batu kapur yang berkabut pekat. Di ujung tebing, Maran berdiri tegak dengan jubah compang-camping berkibar ditiup angin anomali, menatap jurang kabut sambil mencatat di buku kulitnya).*

* **SFX:** *WSHHH... (Angin tebing berhembus dingin).*

* `[TEXTBOX - Potret: Maran_Netral]`  
  **Maran:**  
  "Selamat datang di lingkaran kausalitas tertutup, Saka... Di mana asal usul dan akhir takdir adalah titik simpul yang sama."

* `[TEXTBOX - Potret: Saka_Waspada]`  
  **Saka:** *(Menatap tajam ke arah Maran)*  
  "Maran... Kau selalu muncul di setiap era yang kukunjungi. Apa sebenarnya tujuanmu mengawasi keluargaku?"

* `[TEXTBOX - Potret: Maran_Netral]`  
  **Maran:**  
  "Aku mengawasi benang realitas yang kian menipis setiap kali kau mengubah ranting masa lalu. Manusia yang berjalan melawan arus waktu... Apakah kau yakin adikmu itu pantas diselamatkan jika harganya adalah terhapusnya eksistensimu sendiri dari sejarah semesta?"

* **[INTERACTIVE DIALOGUE BRANCH 4 — PILIHAN DIALOG TEBING]**
  * **PILIHAN A (CURIGA / MENGANCAM):**  
    * `[TEXTBOX - Potret: Saka_Tekad]`  
      **Saka:** *(Mencabut Keris Pasupati, bilah api berkobar mengancam)*  
      "Cukup basa-basimu! Siapa kau sebenarnya?! Bekerja untuk parasit Kala?! Jawab atau kutebas jubahmu sekarang juga!"  
    * `[TEXTBOX - Potret: Maran_Kecewa]`  
      **Maran:** *(Menghela napas dingin, menutup buku catatannya)*  
      "Masih dibutakan oleh amarah yang dangkal... Sangat disayangkan, anak muda." *(Maran lenyap ke dalam bayangan udara)*  
    * **KONSEKUENSI GAMEPLAY (Environmental Hazard):** Turbulensi temporal memicu **Hazard Angin Puyuh Kronal** di area tebing (kontrol platforming melayang menjadi licin & berisiko jatuh).

  * **PILIHAN B (EMPATIK / BIJAK & PENASARAN):**  
    * `[TEXTBOX - Potret: Saka_Hangat]`  
      **Saka:** *(Menurunkan bilah pedangnya, menyarungkannya kembali ke pinggang)*  
      "Kau bicara soal harga kebebasan waktu... Jika kau adalah pengamat abadi, kau pasti tahu rasa sakitnya melihat orang yang kau sayangi direnggut paksa di depan matamu. Katakan padaku, Maran... apa yang harus kulakukan untuk menyelamatkannya tanpa merusak semesta ini?"  
    * `[TEXTBOX - Potret: Maran_SenyumTipis]`  
      **Maran:** *(Tersenyum tipis mengakui kedewasaan nurani Saka)*  
      "Keteguhan hatimu tidak goyah oleh paradoks takdir... Pegang ini, Saka. Mungkin ini bisa menyambung seutas napasmu di saat tergelap."  
    * *(Maran melemparkan sebuah silinder kronal bercahaya keemasan ke tangan Saka, lalu melangkah mundur menghilang di balik kabut tebing).*  
    * **KONSEKUENSI GAMEPLAY (ITEM REWARD):** Mendapatkan **`[Kapsul Kronal Maran]`** (**Fitur Pasif 1x Auto-Revive: Jika HP Saka menyentuh 0 di Act 2, waktu rewind mundur 5 detik & pulih 3 Hati instan (baseline backlog sementara)!**).

*(Tiba-tiba langit tebing retak ungu memancarkan gelombang singularitas masif! Saka terseret pusaran angin badai meloncat melintasi abad menuju era keemasan Majapahit Abad ke-15!).*

---

### **[act2_06] SCENE 6: Gerbang Kota Bata Merah Majapahit & Badai Singularitas (Abad ke-15)**
*(Layar bergetar kencang. Saka terhempas mendarat di atas tembok benteng bata merah raksasa Megalopolis Majapahit Abad ke-15. Di belakangnya, Badai Singularitas Ungu raksasa menggulung dengan kecepatan 4.5 m/s, melahap bangunan bata dan tanah!).*

---

#### **BAGIAN A: High-Octane Singularitas Chase & Blind Leap di Udara (`[Q]` mid-air)**

* `[TEXTBOX - Potret: Saka_Panik]`  
  **Saka:** *(Menatap ke belakang, pupil matanya mengecil melihat gelombang kehampaan kosmik)*  
  "Badai singularitasnya menyusulku! Tanahnya mulai runtuh... Aku harus lari secepat mungkin!"

* `[TUTORIAL OVERLAY — BLIND LEAP TIME-SWITCHING]`  
  * Lari cepat (**Sprint `[Shift]`**). Perhatikan petunjuk **Arkeo-Optics Wireframe Ghost** di celah rintangan!
  * **Lompat ke arah jurang kosong atau tembok buntu, lalu TEKAN `[Q]` DI UDARA!** Dunia akan berganti instan dari Abad 15 ke pipa/kanal maglev 2150 untuk mendarat mulus!

* `[ACTION SEQUENCE 1 — TEMBOK BUNTU ABAD 15]`  
  *Saka berlari kencang ➔ Tembok benteng bata merah buntu di depan ➔ Saka melompat ke arah tembok ➔ **TEKAN `[Q]` DI UDARA!** ➔ Di 2150 tembok tersebut menjadi celah pipa ventilasi maglev ➔ Saka meluncur (**Slide `[Ctrl]`**) menerobos semburan uap dingin!*

* `[ACTION SEQUENCE 2 — JURANG KOSONG 2150]`  
  *Pipa maglev 2150 terputus di ketinggian langit ➔ Saka melompat terjun bebas ke jurang hampa ➔ **TEKAN `[Q]` DI UDARA!** ➔ Seketika muncul atap genteng kayu Gapura Paduraksa Majapahit tepat di bawah kaki Saka!*

* `[ACTION SEQUENCE 3 — LASER GRID 2150]`  
  *Pintu gerbang diblokade kisi-kisi laser merah mematikan di 2150 ➔ Saka melompat dan menekan **`[Q]`** ➔ Berubah menjadi balok kayu kerek bendungan Abad 15 yang bisa dipanjat untuk melontarkan diri ke pelataran bengkel pandai besi!*

---

#### **BAGIAN B: Menemukan Pusaka Nusantara 2 — TOMBAK KUNTA (`[K]`)**

*(Saka menerobos masuk ke dalam sisa reruntuhan bengkel pandai besi kerajaan Majapahit yang melayang di persimpangan dua era. Di tengah landasan tempa, tertancap sebilah mata tombak purba bercahaya jingga-kebiruan pekat).*

* `[ACTION PROMPT — TAHAN E UNTUK MENYATUKAN PUSAKA KUNTA KE SABUK]`

*(Saka menggenggam tangkai tombak Kunta. Sabuk Chronos menyerap modul kinetik tombak, mengubah lengan kanan Saka diselimuti pelat zirah plasma berat).*

* **SFX:** *KLIK-KRAAAK... BOOOMMM-SHINGGG!*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:**  
  "Pusaka kedua... **Tombak Kunta!** Senjata kinetik berdaya tembus tinggi. Gerbang baja komposit dan perisai kristal anomali bukan lagi halangan!"

* `[UNLOCKED: SERANGAN KINETIK TOMBAK KUNTA (TOMBOL K / KLIK KANAN)]`  
  *Gunakan `[K]` untuk menembakkan proyektil plasma berat penembus perisai dan penghancur pintu gerbang tebal!*

*(Saka menembakkan Kunta `[K]` menghancurkan gerbang besi bendungan Majapahit yang terkunci, lalu melangkah keluar menuju arena puncak bendungan).*

---

### **[act2_10] SCENE 10: Puncak Bendungan Melayang — Boss Fight TARA HALF-VESSEL**
*(Layar melebar sinematik. Di puncak bendungan kanal Majapahit yang melayang di atas pusaran singularitas kosmik, Saka tertegun menatap sosok gadis yang melayang di tengah badai).*

* **SFX:** *WUBBB... WUBBB... (Denyut gelombang anomali rendah yang menekan dada).*

---

#### **BAGIAN A: Wujud Tara Setengah Manusia & Pertarungan Batin (Branch 5)**

*(Tara melayang di udara. Tubuh sebelah kirinya masih gadis berusia 17 tahun mengenakan jaket lusuh dan kalung tali pemberian Saka, pipinya basah oleh air mata. Namun tubuh sebelah kanannya telah mengeras menjadi zirah batu hitam pekat, dialiri urat nadi ungu berpendar, cakar bayangan raksasa, dan mata kanan menyala tanpa pupil).*

* `[TEXTBOX - Potret: Saka_Hancur]`  
  **Saka:** *(Lututnya gemetar, matanya membelalak tak percaya)*  
  "T-Tara...? Apa yang... apa yang monster keparat itu lakukan padamu?!"

* `[AUDIO DIRECTION: BINAURAL DOUBLE-VOICE]`  
  *(Suara terdengar tumpang tindih antara rintihan pilu Tara dan tawa menggelegar Batara Kala).*

* `[TEXTBOX - Potret: Adik_Half_Vessel]`  
  **Tara (Suara Bergetar Menangis):**  
  *"K-Kakak... tolong... dingin banget... tubuhku nggak mau nurut..."*

* `[TEXTBOX - Potret: Adik_Half_Vessel]`  
  **Batara Kala (Suara Berat Menggema):**  
  *"Hahaha! Ratapan yang sia-sia, anak manusia! Wadah murni ini telah menyerahkan jiwanya pada sang waktu! Menyerahlah, atau hancur bersama adik kesayanganmu!"*

* **[INTERACTIVE DIALOGUE BRANCH 5 — KONFRONTASI DENGAN TARA]**
  * **PILIHAN A (FOKUS AMARAH PADA KALA / MARAH):**  
    * `[TEXTBOX - Potret: Saka_Tekad]`  
      **Saka:** *(Menodongkan bilah pedang penuh amarah membara)*  
      "Keluarlah dari tubuh adikku, dewa parasit keparat! Hadapi aku sendiri kalau kau punya nyali!!"  
    * `[TEXTBOX - Potret: Adik_Half_Vessel]`  
      **Batara Kala:** *"Beraninya cacing tanah menantang penguasa takdir! Rasakan kehancuranmu!"*  
    * **KONSEKUENSI BOS (HARD MODE):** Batara Kala murka ➔ Kecepatan proyektil dan frekuensi serangan bos **NAIK +15%** sepanjang pertarungan!

  * **PILIHAN B (FOKUS KASIH SAYANG / MEMANGGIL NAMA TARA):**  
    * `[TEXTBOX - Potret: Saka_Hangat]`  
      **Saka:** *(Menurunkan pedangnya sedikit, suaranya bergetar penuh kehangatan)*  
      "Tara! Dengar suara Kakak! Ingat kalung liontin yang Kakak buatkan buat kamu?! Ingat janji kita mau sarapan lontong kari Mak Inah dan liburan ke pantai berdua?! Lawan monster itu, Dek! Kakak ada di sini!"  
    * `[TEXTBOX - Potret: Adik_Half_Vessel]`  
      **Tara:** *(Mata kirinya berair, tangan kirinya bergerak mencengkeram cakar bayangan kanannya sendiri)*  
      *"K-Kakak... aku... aku ingat... AAAAAKKHH! L-Lawan aku, Kak... hancurkan kristalnya sekarang!!"*  
    * **KONSEKUENSI BOS (EMOTIONAL ADVANTAGE):** Kesadaran batin Tara memberontak dan menahan tubuhnya sendiri selama **4 detik di awal pertarungan**, memberi celah serangan bebas yang **MEMOTONG 10% TOTAL HP BOS SECARA INSTAN!**

---

#### **BAGIAN B: Fase 1 — Shield of Memories & Void Spores (HP 100% ➔ 50%)**

* `[GAMEPLAY COMBAT PHASE 1]`  
  * Bos melayang di tengah arena, dilindungi oleh **Kubah Kristal Bayangan Ungu** kebal pedang biasa.
  * Bos menembakkan hujan spora waktu melingkar yang meledak di lantai arena.
  * **Strategi:** Saka menembakkan **Pusaka Kunta `[K]`** untuk memecahkan kubah kristal ungu, lalu meluncur mendekat dan melancarkan kombo tebasan api **Pasupati `[J]`** ke inti anomali dada Tara!

---

#### **BAGIAN C: Fase 2 — Anti-Gravity Arena & Dimension Floor Blast (HP 50% ➔ 0%)**

* `[CUTSCENE MID-FIGHT]`  
  *(Batara Kala menggeram murka. Lantai bendungan Majapahit pecah berkeping-keping melayang di udara gravitasi nol! Gelombang energi merah menyapu seluruh lantai batu Abad 15).*

* `[GAMEPLAY COMBAT PHASE 2]`  
  * **Hazard Peringatan:** Lantai batu Abad 15 memancarkan pendar merah tanda *Floor Annihilation Beam* yang mematikan dalam 2 detik.
  * **Solusi Lintas Waktu:** Saka harus segera menekan **`[Q]`** untuk berpindah ke bangkai gerbong Maglev 2150 yang melayang di udara untuk menghindari semburan laser bawah, lalu melompat balik ke Abad 15 untuk menebas kristal anomali di punggung Tara!

---

#### **BAGIAN D: Klimaks Pertarungan, Unlock Pusaka 3 [CAKRA BASUNANDA], & Transisi ke Act 3**

*(HP Bos menyentuh 0. Saka melancarkan tebasan pamungkas Keris Pasupati tepat ke kristal anomali di dada Tara. Kubah kristal meledak berkeping-keping menjadi pecahan cahaya emas suci!).*

* **SFX:** *KRAAAKKK-SHIIINGGG!! (Ledakan energi resonansi purba).*

*(Dari dalam reruntuhan altar bendungan yang hancur, melayang keluar pusaka ketiga: sebilah cakram logam emas bercahaya surya berputar kencang: **CAKRA BASUNANDA (Cakram Pemotong Garis Takdir)**!).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Menangkap gagang Cakra Basunanda di udara)*  
  "Pusaka ketiga... Cakra Basunanda! Senjata yang mampu memutus benang ikatan anomali!"

*(Saka melompat hendak memotong benang waktu ungu yang menjerat leher Tara. Namun sebelum bilah Cakra menyentuh benang tersebut, jeritan menggelegar Batara Kala mengguncang realitas semesta).*

* `[TEXTBOX - Potret: Kala_Aura_Menakutkan]`  
  **Batara Kala:**  
  *"KAU TERLAMBAT, ANAK MANUSIA! Jiwa dan raga wadah ini sudah terikat dengan jantung pusaran masa lalu! Jika kau ingin adiknya selamat, susul kami ke tempat di mana takdir tanah ini pertama kali ditulis ribuan tahun lalu!!"*

* **SFX:** *VOOOIDDDD-CRACKLEEE!! (Pusaran lubang hitam singularitas kosmik menelan raga Tara, menariknya melompati seribu tahun ke masa lalu menuju Kawah Purba Mataram Kuno!).*

* `[TEXTBOX - Potret: Saka_Tekad]`  
  **Saka:** *(Mendarat di atas batu apung, menggenggam Cakra Basunanda dan Pasupati dengan tatapan mata menyala tekad baja)*  
  "Ke ujung waktu mana pun kau membawanya... aku akan datang meremukkanmu, Kala!"

*(Saka mengaktifkan putaran maksimal Chronos-Belt, melompat menerobos pusaran portal singularitas menuju pertempuran final di Act 3!).*

* `[SFX]`: *WHOOOOSHHH-FLASHHH!! (Layar memutih terang benderang).*

---

```
========================================================================================
                        KALA: SINGKAP GARIS WAKTU
                     --- ACT 2 SANG PENGAMAT CLEAR ---
========================================================================================

  [STATUS PROGRESSI EKSPEDISI]
  • Era Selesai      : Rimba Padjadjaran (Abad 14) & Megalopolis Majapahit (Abad 15)
  • Pusaka Diperoleh : [KERIS PASUPATI] + [TOMBAK KUNTA] + [CAKRA BASUNANDA]
  • Status Relasi    : Rahasia Kakek Terungkap & Maran Memberi Restu Kapsul Kronal
  • Destinasi Final  : The Temporal Sanctum — Kawah Purba Mataram Kuno (Act 3)

========================================================================================
```

<div class="page-break"></div>

---

# ACT 3: THE TEMPORAL SANCTUM (KLIMAKS FINAL)
*(Setting: Kawah Vulkanik Mataram Kuno, Abad ke-9 & Singularity Void)*

---

### **[act3_01] SCENE 1: Pembersihan Altar Ruwatan Ordo Penjaga Waktu**
*(Saka mempelajari bahwa garis darah keluarganya adalah Ordo Ruwatan pelindung kemurnian waktu. Saka harus menurunkan indikator `[KALA INFLUENCE %]` di Altar Utama).*

* **[INTERACTIVE DIALOGUE BRANCH 6 (ENVIRONMENTAL)]**
  * **PILIHAN A (BRUTE FORCE KUNTA):**  
    * Saka menembakkan ledakan Kunta menghancurkan altar utama seketika.  
    * **KONSEKUENSI:** Penurunan Kala Influence instan (**-30%**), namun memicu **Ambush Event brutal** dari monster elit sekte Kala (harus bertahan hidup selama 2 menit).
  * **PILIHAN B (PURIFIKASI SISTEMATIS ARKEO-OPTICS):**  
    * Saka memecahkan puzzle ukiran batu kuno secara bertahap menggunakan pemindai bionik.  
    * **KONSEKUENSI:** Memerlukan waktu memecahkan puzzle mini-game, penurunan Kala Influence stabil (**-20%**), tanpa Ambush, dan membuka pusaka **Tirta Amerta** dengan **Buff Pasif Regenerasi Darah**.

---

### **[act3_02] SCENE 2: Pertarungan Puncak di Singularity Void & The Separation**
*(Saka bertarung menghindari pusaran kosmik Tara Stage 4. Barrier pelindung hancur, dada Tara memancarkan jalinan benang waktu. Saka mengayunkan Cakra Basunanda. Kala memanipulasi suara Tara memohon agar tidak dilukai).*

* **[INTERACTIVE DIALOGUE BRANCH 7 (FINAL QTE CHOICE)]**
  * **PILIHAN A (RAGU-RAGU / HESITATION):**  
    * Saka gemetar melihat wajah Tara ➔ Jendela QTE menjadi sangat sempit (0.5 detik).  
    * **KONSEKUENSI:** Ledakan balik gravitasi **mengurangi 2 Hati Saka** sebelum masuk ke Phase 3 (True Form Kala).
  * **PILIHAN B (TEGUH PENDIRIAN / RESOLVE):**  
    * `[TEXTBOX - Potret: Saka_Tekad]`  
      **Saka:** "Maafkan Kakak, Tara... tapi Kakak harus membebaskanmu!"  
    * **KONSEKUENSI:** **Perfect QTE**. Tebasan Cakra memotong benang waktu dengan bersih. Tara terlepas dan pingsan selamat (Stage 5). Saka masuk ke Phase 3 dengan **Ultimate Attack (Senjata Pemutus Waktu) yang sudah terisi penuh 100%**.

* **Klimaks:** Saka mengeksekusi wujud raksasa kosmik Sang Hyang Kala di Singularity Void (*Root Erasure*), memusnahkan eksistensinya dari seluruh akar garis waktu semesta!

---

# [epi_01] EPILOG: THE BITTERSWEET RESET (FAJAR ARUNIKA)
*(Setting: Tahun 2150 Baseline Timeline — Megapolis Astanapura)*

*(Layar fade in dari hitam. Suara alarm pagi berdering di kamar apartemen rusunawa yang bersih dan cerah).*

*(POV BERUBAH MENJADI POV TARA):*
* Tara terbangun dari tidurnya, tersenyum segar menyambut matahari pagi.
* Di dalam kamar itu, tidak ada Saka, tidak ada meja solder, dan tidak ada sabuk rongsokan. Tara hidup normal dan mandiri.
* Tara sarapan sepiring lontong kari hangat di mejanya, lalu keluar rumah dan berjalan menyusuri jembatan penyeberangan Sektor 4 bersama teman-teman sekolahnya sambil tertawa riang.

*(Kamera berpindah ke sudut pandang Saka):*
* Di tengah jembatan penyeberangan, Tara berpapasan melintasi seorang pria berjaket lusuh yang mengenakan sabuk aneh di pinggangnya (**Saka**).
* Karena medan insulasi Chronos-Belt melindunginya dari penghapusan eksistensi, Saka tetap hidup namun status keberadaannya terhapus dari memori garis waktu baru.
* Tara sempat berhenti sejenak dan menoleh ke arah Saka karena merasakan kehangatan yang familiar, namun Tara tidak mengenali siapa pria itu dan kembali melanjutkan jalannya.

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Tersenyum bangga dengan mata berkaca-kaca menatap punggung adiknya yang menjauh)*  
  "Jaga diri baik-baik ya, Tara."

*(Maran muncul dari balik tiang jembatan, berdiri tenang di samping Saka sambil menutup buku catatannya).*

* `[TEXTBOX - Potret: Maran_SenyumTipis]`  
  **Maran:**  
  "Sekarang kau mengerti arti kata-kataku di Padjadjaran, Saka... Garis waktu ini telah selamat, namun kau telah membayar harganya dengan menjadi anomali abadi seperti diriku."

* `[TEXTBOX - Potret: Saka_Hangat]`  
  **Saka:** *(Menatap langit Astanapura yang biru cerah tanpa retakan)*  
  "Selama Tara bisa hidup bahagia di bawah langit damai ini... itu bukan harga yang mahal."

* `[TEXTBOX - Potret: Maran_SenyumTipis]`  
  **Maran:**  
  "Selamat datang di antara para penjaga garis waktu, Saka."

*(Layar perlahan fade to black).*

* **TAGLINE PENUTUP:**  
  *“Tidak semua yang hilang harus ditemukan kembali.”*

---
*Draft cerita sekitar 60%. Naskah yang ada dipertahankan untuk revisi; tidak dinyatakan selesai atau dikunci canon oleh revisi produksi ini.*
