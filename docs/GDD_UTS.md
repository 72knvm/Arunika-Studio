# KALA: Singkap Garis Waktu

Game Design Document

Arunika Studio | 10 Oktober 2026


## 01  GAME OVERVIEW

### Konsep dan pengalaman pemain

KALA: Singkap Garis Waktu adalah game puzzle-platformer naratif 2D pixel art bertema Sains Fiksi Nusantara. Pemain menjadi Saka, arkeo-mekanik dari Astanapura tahun 2150, yang menjelajahi dua era untuk menyelamatkan adiknya, Tara, dari Sang Hyang Kala. Tindakan di masa lalu mengubah rintangan di masa depan dalam satu garis waktu yang sama.

| Aspek | Rancangan |
| --- | --- |
| Judul | KALA: Singkap Garis Waktu |
| Developer | Arunika Studio |
| Genre | Puzzle-platformer 2D, narrative adventure, dengan progresi kemampuan Metroidvania-lite |
| Tema | Sains Fiksi Nusantara: teknologi kronal, sejarah peradaban Nusantara, dan mitologi sebagai kosmologi fiksi |
| Pemain | Single player, satu pemain secara lokal |
| Target audiens | Remaja hingga dewasa muda, 13–24 tahun; menyukai cerita, eksplorasi, dan teka-teki lingkungan |
| Platform utama | PC Windows, distribusi prototype melalui itch.io |
| Gaya visual | 2D pixel art dengan background berlapis dan animasi sprite |

#### Game elements

Aktivitas inti pemain adalah membaca lingkungan, memindai petunjuk, menemukan titik perpindahan era, mengubah objek di masa lalu, dan mencoba hasilnya di masa depan. Pemain juga bergerak melewati rintangan, menyelinap dari patroli, berbicara dengan NPC, serta mengelola Hati dan medkit. Keris Pasupati membuka aksi serangan pada akhir Act 1.

#### Pengalaman yang dituju

Rasa puas utama datang ketika pemain memahami hubungan sebab-akibat: sebuah jalan yang semula tertutup menjadi terbuka karena keputusan yang ia ambil pada era sebelumnya. Hubungan Saka dan Tara memberi alasan personal untuk menjelajah, sementara lokasi dan kehidupan Nusantara memberi konteks bagi teka-teki.


## 01  GAME OVERVIEW

### Pondasi desain dan batas pengembangan

| Pondasi | Penerapan dalam permainan |
| --- | --- |
| Kausalitas yang terbaca | Perubahan di masa lalu mempunyai akibat yang dapat dilihat dan dijelaskan di masa depan. Puzzle tidak bergantung pada menebak tombol secara acak. |
| Pengetahuan melalui eksplorasi | Arkeo-Optics, lontar, dan percakapan memberikan petunjuk sebelum pemain mengambil tindakan. Saka dan pemain mempelajari aturan dunia bersama. |
| Nusantara sebagai dasar dunia | Permukiman pesisir, galangan perahu, rempah, bangunan kuno, dan pusaka memengaruhi lokasi serta interaksi. Detail budaya ditinjau selama produksi. |
| Ikatan Saka dan Tara | Adegan keseharian sebelum tragedi memperkenalkan hubungan keduanya. Pilihan percakapan mempunyai konsekuensi yang tercatat. |

#### Tiga lapisan cakupan

| Cakupan | Isi dan hasil yang dituju |
| --- | --- |
| Prototype inti | Satu ruangan puzzle bendungan dua era. Movement, interaksi, scan, Historical Anchor, perubahan danau, dan checkpoint membuktikan mekanik utama. |
| Target demo | Prolog dan Act 1 Sriwijaya. Menghubungkan cerita awal, stealth, percabangan rute, puzzle bendungan, pertemuan Maran, dan kebangkitan Pasupati. |
| Game penuh | Act 2, Act 3, dan Epilog. Padjadjaran, Majapahit, Mataram Kuno, upgrade sabuk, pusaka lanjutan, dan akhir cerita menjadi pengembangan berikutnya. |

#### Durasi dan konten prototype

Prototype tugas ditargetkan dapat diselesaikan dalam sedikitnya 5 menit dan memiliki minimal tiga jenis konten unik. Rencana kontennya mencakup puzzle lingkungan dua era, stealth/QTE, dan interaksi NPC dengan percabangan rute. Demo Prolog + Act 1 memiliki sasaran pengembangan 25–30 menit, yang perlu dibuktikan melalui playtest; angka itu bukan durasi build yang sudah terukur.

Urutan produksi dimulai dari puzzle inti, dilanjutkan integrasi Prolog dan Act 1. Climbing lanjutan, wall-jump, rewind otomatis, boss Tara, dan pusaka Kunta/Cakra/Tirta tidak menjadi dependensi penyelesaian prototype inti.


## 02  TECHNICAL SPECS

### Bentuk teknis dan struktur permainan

| Spesifikasi | Rancangan |
| --- | --- |
| Technical form | Game 2D dengan sprite pixel art dan collision 2D. |
| View | Side view / sidescroller; kamera mengikuti pemain secara horizontal dengan batas per scene. |
| Engine | Godot Engine 4.7.x. Versi patch dikunci tim sebelum ekspor build. |
| Bahasa | GDScript. Data dialog dan parameter gameplay dipisahkan dari controller. |
| Platform | Windows sebagai target utama. Versi browser merupakan opsi setelah build Windows stabil. |
| Input | Seluruh aksi utama tersedia melalui keyboard. Mouse hanya menjadi alternatif tambahan. |
| Display | Target komposisi 16:9. Ukuran kerja proyek saat ini 1672 × 941; sampling nearest untuk menjaga ketajaman sprite. |
| Distribusi | Build prototype dan petunjuk kontrol diunggah ke itch.io. |
| Audio | BGM per suasana dan SFX untuk interaksi, keberhasilan, bahaya, serta perpindahan era. |

#### Layout dunia

Dunia dibagi menjadi scene dengan pintu, trigger, atau Historical Anchor sebagai penghubung. Setiap lokasi memiliki batas kamera, lantai yang dapat dilalui, objek interaktif, checkpoint, dan tujuan pemain. Pasangan scene dua era mempertahankan posisi geografis yang dapat dibandingkan, dengan perubahan objek serta kondisi lingkungan.

#### Character game

Player adalah Saka. Tara, Ki Pranata, dan Maran menjadi karakter cerita/NPC. Prajurit patroli menjadi tantangan stealth; Utusan Kala menjadi ancaman pada klimaks Act 1. Arkeo-Optics berfungsi sebagai alat informasi, Chronos-Belt sebagai alat perpindahan era, dan Keris Pasupati sebagai senjata pertama.

#### Aturan state

Data progres menyimpan era, Hati, stok medkit, kemampuan yang terbuka, pilihan dialog, dan perubahan puzzle. Checkpoint menyimpan snapshot yang utuh. Perpindahan scene atau era tidak menghapus dampak tindakan pemain.


## 02  TECHNICAL SPECS

### Game flow dan progresi demo

Alur berikut menggambarkan rancangan menu, sesi permainan, kegagalan, dan akhir demo. Transisi scene mempertahankan flag progres; restart dari checkpoint memulihkan keadaan yang disimpan.

[Diagram: gameflow]

#### Progresi naratif demo

Kamar dan keseharian Saka–Tara memperkenalkan gerak, scan, serta hubungan karakter. Tragedi jembatan memicu usaha mengambil Chronos-Belt. Setelah memperoleh sabuk, Saka tiba di Sriwijaya, mencari petunjuk, melewati rute stealth atau drainase, mengubah bendungan, menemui Maran, dan mencapai kuil.

Kebangkitan Keris Pasupati menjadi klimaks demo. Layar Demo Clear menutup sesi dengan teaser perjalanan berikutnya. Prototype inti dapat memakai sabuk yang sudah aktif di ruangan uji terpisah untuk memvalidasi mekanik; susunan itu tidak mengganti urutan perolehan sabuk dalam cerita.

#### Transisi aman

Selama fade, perpindahan era, dialog, atau cutscene, kontrol yang tidak relevan dikunci. Pemain muncul pada posisi aman. Pergantian era ditolak bila tempat tujuan terhalang collision, sehingga pemain tidak masuk ke dalam objek atau langsung jatuh akibat perpindahan.


## 03  GAMEPLAY

### Cara bermain dan kondisi penyelesaian

#### Deskripsi sesi

Pemain melihat sebuah danau asam menghalangi jalan menuju kuil di tahun 2150. Scan menjelaskan bahwa sumbernya adalah sungai yang sudah mengalir sejak era Sriwijaya. Pemain kembali ke Historical Anchor, berpindah ke 682 M, mencapai katup bendungan, lalu mengalihkan sungai. Ketika kembali ke 2150, danau telah surut dan jalur menuju kuil bisa dilalui. Pemain melihat perubahan dunia sebagai hasil tindakannya sendiri.

#### Mode permainan

Mode utama berupa petualangan naratif single player. Pemain menjelajah scene berurutan dengan percabangan rute lokal. Pilihan jalur kembali bertemu pada tujuan utama yang sama; konsekuensi dialog disimpan untuk adegan berikutnya. Prototype puzzle inti menjadi scene uji tersendiri selama pengembangan.

| Kondisi | Definisi |
| --- | --- |
| Menang pada puzzle | Pemain mengaktifkan perubahan kausalitas dan menyeberangi rintangan yang sebelumnya menghalangi jalan. |
| Menang pada level | Tujuan scene selesai dan pemain mencapai trigger menuju scene berikutnya. |
| Kalah | Hati habis, terkena hazard fatal, tertangkap pada stealth sebelum senjata tersedia, atau gagal pada countdown yang diwajibkan. |
| Pemulihan | Game menampilkan kegagalan lalu memulihkan snapshot checkpoint. Pemain dapat mencoba kembali tanpa kehilangan aturan puzzle. |
| Demo selesai | Pemain menyelesaikan rangkaian Act 1, memperoleh Pasupati, melakukan finisher pengenalan, dan mencapai layar Demo Clear. |
| Game penuh selesai | Saka memutus hubungan Kala dengan Tara, menghadapi Kala di Singularity, dan mencapai Epilog sesuai arah cerita. |

#### Fokus dan keseruan

Fokus utama berada pada puzzle temporal dan eksplorasi cerita. Stealth menambah ketegangan saat pemain belum memiliki senjata. Pilihan dialog mengubah jalan atau sumber daya, sehingga pemain mempertimbangkan sikapnya. Pertarungan awal memperkenalkan progresi kemampuan tanpa menggantikan puzzle sebagai pusat permainan.


## 03  GAMEPLAY

### Kontrol pemain dan prioritas input

| Input keyboard | Aksi dan konteks |
| --- | --- |
| A / D atau panah kiri / kanan | Berjalan horizontal. |
| Shift ditahan | Sprint pada area gameplay yang mengizinkan. |
| Space | Melompat; keluar dari cover; mengonfirmasi dialog atau QTE sesuai konteks aktif. |
| C / Ctrl | Merunduk atau slide di bawah rintangan sesuai scene. |
| E | Interaksi objek, masuk cover, konfirmasi QTE, rapid tap pintu, atau hold katup/sabuk. Prompt menjelaskan jenis tekan yang diperlukan. |
| F | Scan objek melalui Arkeo-Optics. |
| Q | Time-Switch pada Historical Anchor. |
| H / 1 | Menggunakan satu medkit untuk memulihkan satu Hati. |
| M | Membuka Peta Lontar setelah item diperoleh. |
| J | Serangan melee setelah Keris Pasupati terbuka. |
| K | Serangan Kunta pada pengembangan Act 2; belum menjadi kontrol aktif prototype inti. |
| Esc | Rancangan pause / kembali ke menu sebelumnya; tersedia hanya ketika konteks mengizinkan. |

#### Mouse sebagai alternatif

Klik tengah dapat menggantikan scan F. Klik kiri dapat menggantikan melee J atau konfirmasi QTE aktif. Klik kanan menjadi alternatif K pada Act 2. Semua fungsi tersebut tetap mempunyai padanan keyboard sehingga mouse tidak menjadi syarat bermain.

#### Satu tombol menjalankan satu konteks

Urutan prioritas input adalah modal/QTE, cutscene/dialog, cover, lalu interaksi dunia. Menekan Space untuk melanjutkan dialog tidak sekaligus membuat Saka melompat. Klik kiri pada QTE tidak sekaligus menyerang. Prompt kontekstual menunjukkan aksi yang sedang berlaku.

#### Tutorial bertahap

Kamar mengenalkan gerak dan scan; jembatan mengenalkan navigasi; keadaan darurat mengenalkan input cepat/hold. Sriwijaya mengenalkan cover, QTE, peta, dan Time-Switch. Serangan melee baru diperkenalkan saat Pasupati tersedia.


## 04  KEY FEATURES

### Fitur utama KALA

#### Puzzle dua era dalam satu garis waktu

Pemain membandingkan lokasi masa lalu dan masa depan untuk memahami akar sebuah rintangan. Perubahan bendungan pada 682 M mengubah keadaan danau di 2150. Puzzle meminta observasi, pengetahuan, dan tindakan yang saling berhubungan.

#### Historical Anchor sebagai bagian dari level

Chronos-Belt hanya bekerja pada titik resonansi yang stabil. Pembatasan ini membuat posisi perpindahan menjadi bagian dari teka-teki, serta menjaga jalur platforming dan stealth tetap bermakna. Umpan balik menjelaskan kegagalan aktivasi ketika pemain berada di luar anchor.

#### Nusantara dan teknologi kronal

Lingkungan masa lalu membentuk objek interaktif, pola perjalanan, serta petunjuk pengetahuan. Sriwijaya menghadirkan pesisir, galangan perahu, gudang rempah, drainase, dan bendungan. Astanapura 2150 memperlihatkan interpretasi futuristik kehidupan kota dengan implan, maglev, dan teknologi waktu.

#### Percakapan mengubah cara bermain

Sikap terhadap Ki Pranata menentukan rute darat dengan patroli lebih padat atau jalur drainase melalui Peta Lontar. Respons terhadap Maran mengubah kondisi Hati atau stok medkit sebelum kuil. Pilihan membawa konsekuensi yang bisa dirasakan dalam gameplay.

#### Stealth dengan skill check detak jantung

Saat penjaga memeriksa cover, pemain menekan tombol pada zona timing yang tepat untuk menahan napas. Detak jantung, perubahan audio, dan animasi penjaga memberi tekanan pada momen tertentu, tanpa QTE terus-menerus saat bersembunyi.

#### Motivasi personal kakak dan adik

Tragedi terasa berarti karena pemain terlebih dahulu mengenal kehangatan Saka dan Tara. Perubahan keadaan Tara menjadi penanda perkembangan ancaman Kala. Cerita memberi konteks bagi perjalanan antarzaman dan pengorbanan di akhir game penuh.


## 05  MECHANICS

### Time-Switch dan puzzle kausalitas

#### Design guideline

Pemain harus memahami hubungan tindakan dan hasil melalui petunjuk lingkungan. Objek yang penting dapat dipindai; perubahan era memberikan respons yang terlihat. Desain menghindari perpindahan yang tidak aman, state yang hilang, dan tindakan yang tidak memberi umpan balik.

#### Aturan Time-Switch

| Parameter | Aturan |
| --- | --- |
| Prasyarat | Chronos-Belt sudah diperoleh dan pemain berada di Historical Anchor. |
| Input | Tekan Q ketika prompt perpindahan tersedia. |
| Hasil | Pemain berpindah ke era pasangan pada lokasi yang dapat dibandingkan. |
| Validasi | Posisi tujuan harus memiliki ruang bebas dan lantai aman. Bila tidak aman, perpindahan ditolak. |
| Di luar anchor | Sabuk memberi bunyi macet, lampu peringatan, dan pesan singkat bahwa resonansi tidak tersedia. |
| State persisten | Flag perubahan puzzle dan pilihan dialog tetap tersimpan saat era berganti. |

[Diagram: causality]

#### Objek bendungan

Katup memiliki keadaan belum dialihkan dan sudah dialihkan. Pemain menahan E selama 2–3 detik sebagai target awal interaksi. Progress bar, gerak katup, dan suara aliran air mengonfirmasi aksi. Flag dam_diverted kemudian mengubah danau 2150 menjadi lembah aman. Nilai durasi hold disesuaikan setelah playtest.

#### Definisi sukses dan gagal

Sukses berarti pemain memahami petunjuk, menyelesaikan interaksi katup, kembali ke 2150, lalu mencapai jalur berikutnya. Jatuh atau terkena hazard memulihkan checkpoint. Aktivasi Q yang tidak valid memberi feedback dan mempertahankan posisi pemain.


## 05  MECHANICS

### Cover, patroli, dan QTE detak jantung

#### Cover system

Semak ilalang, kolong peti, dan terpal rempah menjadi objek cover. Pemain menekan E di dekat cover untuk bersembunyi. Sprite menjadi lebih gelap/semitransparan sebagai tanda state tersembunyi, sementara Space mengeluarkan pemain dari cover sesuai konteks. Cover memberi perlindungan dari penglihatan biasa; inspeksi penjaga tetap dapat memicu skill check.

| State penjaga | Perilaku dan feedback |
| --- | --- |
| Patroli | Berjalan pada waypoint. Indikator hijau menyertai bentuk/icon state normal. |
| Mencurigakan | Berhenti 3–4 detik di depan cover untuk menginspeksi. Indikator kuning dan animasi mencari memicu QTE detak jantung. |
| Alarm | Indikator merah dan tanda seru muncul. Penjaga membunyikan peringatan dan mengejar. Sebelum Pasupati tersedia, tertangkap memulihkan checkpoint. |

#### Skill check

Meteran horizontal muncul di atas area pemain, dengan jarum bergerak bolak-balik dan zona target yang jelas. Pemain menekan E tepat ketika jarum berada pada target; klik kiri menjadi alternatif. Kecepatan jarum dan lebar zona target merupakan parameter tuning yang diuji untuk menjaga tantangan tetap terbaca.

| Hasil QTE | Dampak |
| --- | --- |
| Berhasil | Saka meredam napas. Penjaga menghentikan inspeksi dan kembali berpatroli. |
| Meleset / terlambat | Suara batuk atau derak cover mengungkap posisi. Saka keluar dari cover dan penjaga masuk state alarm. |

#### Feedback audio dan visual

BGM meredup saat inspeksi, sementara detak jantung dan napas menjadi dominan. Bentuk jarum dan posisi target mendukung informasi warna. Sukses memberi hela napas dan kembalinya audio normal; kegagalan memberi alarm yang jelas. Pemain tidak diminta menjalankan QTE pada setiap detik bersembunyi.


## 05  MECHANICS

### Hati, medkit, checkpoint, dan senjata

| Sistem | Parameter dan aturan |
| --- | --- |
| Kesehatan | Saka memiliki 5 Hati diskret. Hati tidak memakai pecahan. |
| Damage | Serangan biasa mengurangi 1 Hati; serangan berat mengurangi 2. Hati habis memicu kegagalan. |
| Hazard fatal | Jurang, danau asam, atau plasma memicu respawn checkpoint sesuai area. |
| Medkit | Maksimum stok 3. H atau 1 mengonsumsi satu item dan memulihkan satu Hati hingga maksimum 5. |
| Pembatasan healing | Medkit tidak dikonsumsi saat Hati penuh. Jika stok penuh, pickup tetap tersedia. |
| Pickup | Stimpack pada era 2150 dan herbal pada area masa lalu menambah satu stok medkit. |
| Checkpoint | Menyimpan scene, posisi aman, era, Hati, medkit, unlock, flag puzzle, dan pilihan dialog. |
| Respawn | Memulihkan seluruh snapshot checkpoint. Flag sesudah checkpoint kembali mengikuti keadaan snapshot itu. |

#### Tools dan senjata

Arkeo-Optics memberikan informasi lingkungan melalui F. Chronos-Belt membuka Time-Switch pada anchor melalui Q. Peta Lontar memberikan petunjuk rute drainase melalui M. Keris Pasupati terbuka pada akhir Act 1, dipakai melalui J untuk pengenalan melee dan finisher. Kunta, Cakra Basunanda, serta Tirta Amerta merupakan pengembangan game penuh.

#### Aksi dan feedback

Gerak, sprint, jump, crouch/slide, scan, interaksi, cover, perpindahan era, dan healing memiliki animasi atau indikator yang sesuai. Interaksi hold memakai progress bar. Scan menampilkan teks petunjuk. Pickup memperbarui stok dan memberi suara. Serangan hanya aktif ketika senjata sudah diperoleh.

#### Reward dan punishment

Reward berupa rute baru, informasi, medkit, atau kemampuan. Punishment berupa kehilangan Hati, alarm, rute dengan penjaga lebih banyak, atau kembali ke checkpoint. Balans harus menjaga kegagalan tetap dapat dipelajari dan tidak membuat pemain kehilangan arah.


## 05  MECHANICS

### Percabangan dialog dan konsekuensi

Pilihan disimpan sebagai flag. Cabang mengubah kondisi atau jalan menuju tujuan bersama, sehingga cerita utama tetap dapat dikelola dalam scope demo.

| Pertemuan | Pilihan | Konsekuensi |
| --- | --- | --- |
| Tara, Prolog | Protektif atau jujur tentang peninggalan kakek | Flag disimpan. Gema emosional atau buff pada Act 2 menjadi konsekuensi pengembangan berikutnya, belum aktif di demo. |
| Ki Pranata, Act 1 | Intimidasi / berbohong | Rute darat sulit dengan total 6 penjaga: 4 dasar dan 2 tambahan. |
| Ki Pranata, Act 1 | Bersikap sopan / meminta bantuan | Mendapat Peta Lontar dan akses drainase. Petunjuk simpang kanan–kiri–kanan membuka jalan menuju bendungan. |
| Maran, Act 1 | Agresif atau tidak merespons tepat waktu | Kehilangan 1 Hati saat ini. Maksimum Hati tetap 5. |
| Maran, Act 1 | Menjelaskan tujuan menyelamatkan Tara | Mendapat 1 stok medkit. Kapasitas tetap 3; reward tetap tersedia jika stok penuh. |

#### Cabang game penuh

Act 2 mengembangkan pilihan terhadap Maran dan Tara Half-Vessel. Act 3 mengembangkan pilihan pemurnian altar dan keputusan pada final QTE. Nilai buff, peluang, serta balancing boss adalah rancangan lanjutan yang diuji setelah prototype inti dan demo selesai.

#### Konsistensi informasi

NPC memberikan pengetahuan sesuai kejadian yang sudah dialami Saka. Pilihan dialog tidak mengubah lore secara acak. Konsekuensi yang belum aktif tetap diberi penanda scope agar pemain dan tim tidak menganggap semua cabang telah tersedia dalam demo.

#### Parameter sementara

Target awal mencakup hold katup 2–3 detik, inspeksi penjaga 3–4 detik, dan countdown brankas 60 detik. Kecepatan gerak, tinggi lompatan, jarak vision cone, serta tuning QTE ditetapkan melalui ruangan uji. Angka tersebut ditinjau berdasarkan keterbacaan dan keberhasilan playtest.


## 06  STORYBOARD

### Sinopsis dan aturan dunia

#### Sinopsis

Di kota Astanapura tahun 2150, Saka hidup sebagai arkeo-mekanik bersama adiknya, Tara. Kehangatan pagi mereka terputus ketika langit di atas jembatan robek dan Sang Hyang Kala mengambil Tara sebagai calon wadah. Saka mengambil Chronos-Belt peninggalan kakeknya dan terlempar ke masa Sriwijaya.

Dalam perjalanan antarzaman, Saka mempelajari bahwa sejarah, pusaka, dan garis darah keluarganya terhubung dengan penjagaan waktu. Ia memecahkan rintangan melalui perubahan masa lalu, bertemu pengamat misterius Maran, dan memperoleh kemampuan untuk melawan pengaruh Kala. Game penuh menuju upaya membebaskan Tara, memutus akar Kala, dan menghadapi konsekuensi pemulihan garis waktu.

#### Game world

| Dunia / era | Fungsi naratif dan lingkungan |
| --- | --- |
| Astanapura 2150 | Kota futuristik dengan rusunawa, bengkel, skybridge, maglev, serta teknologi bionik. Lokasi awal dan pasangan kondisi masa depan. |
| Wanua Sriwijaya 682 M | Pesisir, galangan perahu, gudang rempah, dan bendungan. Lokasi utama Act 1 dan pengenalan kausalitas. |
| Padjadjaran dan Majapahit | Rimba, curug, candi, kanal, serta pasangan fasilitas masa depan. Cakupan Act 2. |
| Mataram Kuno dan Singularity | Altar penjaga waktu dan ruang konflik akhir. Cakupan Act 3. |

#### Aturan waktu

KALA memakai satu garis waktu, bukan dunia paralel. Kala berada di luar pengalaman waktu linear dan memerlukan wadah dari darah penjaga. Chronos-Belt menyediakan anchor dan insulasi kronal. Arah Epilog mempertahankan Tara yang selamat serta Saka yang tetap hidup sebagai anomali, namun tidak lagi dikenal dalam garis waktu baru.

Storyboard di GDD merangkum kejadian dan fungsi gameplay. Dialog lengkap, ekspresi, dan penyutradaraan per scene tetap berada pada Story Document agar revisi naskah tidak membuat spesifikasi mekanik sulit dibaca.


## 06  STORYBOARD

### Karakter dan perkembangan Tara

| Karakter | Profil dan fungsi |
| --- | --- |
| Saka, 25 tahun | Arkeo-mekanik dari Astanapura. Analitis, tekun, dan protektif. Mata bionik menjadi identitas visual serta alat scan. Motivasi utama adalah menyelamatkan Tara. |
| Tara, 17 tahun | Adik Saka yang ceria, tangguh, dan keras kepala. Liontin pemberian Saka menjadi penanda hubungan. Darah penjaga menjadikannya target Kala. |
| Ki Pranata, 60 tahun | Tetua pembuat perahu Sriwijaya. Memberi konteks pesisir, penyamaran, serta akses rute berdasarkan sikap Saka. |
| Maran | Pengamat abadi dan anomali. Membawa pengetahuan tentang deviasi waktu, memberi pilihan dan konsekuensi pada perjalanan Saka. |
| Sang Hyang Kala | Entitas kosmik pemangsa garis waktu. Menggunakan Tara sebagai wadah dan menggerakkan konflik utama. |

#### Lima tahap visual Tara

| Tahap | Penanda dan kemunculan |
| --- | --- |
| 1. Normal | Ekspresi hangat dan pakaian keseharian 2150. Prolog dan Epilog. |
| 2. Possessed Awakening | Mata ungu, retakan gelap, dan pose Maestro saat tragedi jembatan. |
| 3. Half-Vessel | Kristal bayangan menutup sebagian tubuh; kesadaran Tara dan Kala bertumpang tindih. Act 2. |
| 4. Full Vessel | Kala mengendalikan bentuk tempur Tara dengan aura kosmik. Act 3. |
| 5. Separated | Tara kembali normal namun lemah setelah benang waktu diputus. Klimaks dan Epilog. |

#### Penyajian emosi

Animasi gameplay menggunakan sprite pixel art dengan siluet yang konsisten. Portrait dialog dapat memperlihatkan ekspresi lebih dekat dalam gaya pixel art yang sama. Perubahan tahap Tara memengaruhi palet, pose, dan efek; identitas rambut, pakaian, serta liontin tetap terbaca.


## 07  ARTWORK & INFLUENCE

### Moodboard pixel art

KALA menggunakan 2D pixel art. Referensi berikut menunjukkan unsur visual yang dituju; gambar adalah screenshot game referensi, bukan aset atau screenshot final KALA.

![Moodboard neon](../tmp/reference-review/moodboard/neon.jpg)
Tales of the Neon Sea — detail lingkungan pixel, kedalaman kota, serta kontras cahaya neon. Sumber: halaman resmi game di Steam [R1].

Penerapan pada KALA: detail rusunawa, bengkel, dan skybridge mendukung aktivitas pemain. Cahaya teknologi menonjolkan objek penting di depan lapisan kota yang lebih tenang.

![Moodboard unbound](../tmp/reference-review/moodboard/unbound.jpg)
A Space for the Unbound — ekspresi karakter dan penyajian cerita melalui pixel art. Sumber: halaman resmi game di Steam [R2].

Penerapan pada KALA: percakapan Saka–Tara memperkuat emosi. Benda, ruang, makanan, dan interaksi memberi identitas Indonesia dalam interpretasi kota fiksi 2150.


## 07  ARTWORK & INFLUENCE

### Atmosfer teknologi dan palet

![Moodboard cyberpunk](../tmp/reference-review/moodboard/cyberpunk.jpg)
Cyberpunk 2077 — pencahayaan teknologi, material industrial, dan suasana kota masa depan. Sumber: halaman resmi game di Steam [R3].

Cyberpunk 2077 menjadi acuan material industrial, implan, dan atmosfer teknologi. Unsur tersebut diterjemahkan ke 2D pixel art sesuai skala tim; warna dan cahaya mengikuti lokasi serta adegan KALA.

#### Palet acuan per lokasi dan suasana

| Lokasi / suasana | Palet acuan |
| --- | --- |
| PROLOG PAGI | #F97316, #FDE68A, #0F172A, #06B6D4 |
| 2150 RERUNTUHAN | #334155, #78350F, #A3A33A, #64748B |
| SRIWIJAYA | #78350F, #15803D, #0284C7, #FDE047 |
| EFEK / PUSAKA | #000000, #581C87, #9333EA, #FBBF24 |

Prolog memakai oranye–emas untuk langit dan cahaya pagi, biru gelap untuk bangunan/interior, serta cyan untuk teknologi. Ungu–hitam muncul saat Kala bermanifestasi; magenta bukan warna dominan Prolog. Emas pusaka menjadi aksen terpisah.

#### Standar pixel art

Sprite karakter, prop, background, portrait, dan UI menggunakan detail pixel yang serasi. Siluet Saka dan Tara harus tetap terbaca pada ukuran gameplay. Animasi walk dan idle mempertahankan proporsi, warna, pivot, serta baseline kaki antarframe. Tim menghindari campuran tepi halus dan pixel tajam pada objek yang berada dalam scene yang sama.

Background berlapis memisahkan langit, kota/laut jauh, lingkungan tengah, jalur pemain, dan foreground. Parallax menjaga kedalaman tanpa mengaburkan jalur. Teknologi mendapat aksen cyan, pusaka emas, dan pengaruh Kala ungu. UI memakai bentuk dan teks agar informasi tidak bergantung pada warna. Aset final dibuat tim; sumber dan hak penggunaan dicatat.


## 08  LEVEL

### Prolog di Astanapura 2150

Prolog memperkenalkan kontrol, hubungan Saka–Tara, dan alasan memulai perjalanan waktu. Input serta objek baru dikenalkan bertahap sebelum pemain menghadapi puzzle kausalitas.

| Scene | Tujuan dan aktivitas | Objek / hasil |
| --- | --- | --- |
| pro_01<br>Kamar Saka | Bangun, mengenali ruang, bergerak, dan memindai meja/peralatan. Aktivitas bengkel memperkenalkan pekerjaan Saka. | Meja solder, modul kabel, Arkeo-Optics, pintu. Transisi ke jembatan. |
| pro_02<br>Skybridge dan kedai | Berjalan bersama Tara, mengenali kota, sarapan di kedai Mak Inah, dan memilih respons tentang peninggalan kakek. | Lampu, maglev, kedai, liontin, dialog. Flag respons Tara tersimpan. |
| pro_03<br>Tragedi jembatan | Menghadapi langit robek, sprint/jump/slide melalui puing, dan berusaha mendekati Tara. | Puing, platform terapung, anomali, liontin jatuh. Tara diambil Kala. |
| pro_04<br>Pintu rusunawa | Kembali ke rusunawa dan membuka pintu macet melalui rapid tap E. | Pintu darurat dan prompt. Membuka akses menuju brankas. |
| pro_05<br>Brankas Chronos-Belt | Memasukkan PIN 2408, mengambil serta mengaktifkan sabuk dalam countdown 60 detik. | Keypad, catatan kakek, sabuk, timer. Transisi kronal menuju 682 M. |

#### Kondisi keberhasilan dan kegagalan

Prolog selesai ketika Saka memperoleh sabuk dan berpindah ke Sriwijaya. Hazard pada jembatan atau countdown yang habis memulihkan checkpoint terkait. Checkpoint sebelum rangkaian darurat mengurangi pengulangan dialog yang sudah dibaca.

#### Materi pengantar

Prompt kontrol muncul ketika mekanik dibutuhkan. PIN dihubungkan dengan ulang tahun Tara, sehingga petunjuk brankas mempunyai konteks cerita. Pemain harus menerima petunjuk sebelum timer menjadi ujian, bukan menemukan informasi wajib setelah kesempatan habis.


## 08  LEVEL

### Act 1 Sriwijaya dan puzzle bendungan

| Scene | Tujuan dan aktivitas | Objek / hasil |
| --- | --- | --- |
| act1_01<br>Pesisir dan galangan | Mencari arah, berbicara dengan Ki Pranata, memperoleh penyamaran, dan memilih sikap. | Perahu, jarik, dialog, Peta Lontar. Flag rute darat/drainase. |
| act1_02<br>Pos penjagaan | Mengenali patroli, cover, QTE detak jantung, dan penggunaan anchor untuk melewati hambatan temporal. | Semak, gerbang, penjaga, anchor. Tutorial Time-Switch. |
| act1_03<br>Gudang, drainase, bendungan | Melewati rute sesuai pilihan, membaca peta, menganalisis danau 2150, dan memutar katup 682 M. | Peti, terpal, 3 simpang, katup, danau asam. Flag dam_diverted. |
| act1_04<br>Lembah dan Maran | Menyeberang dasar danau yang mengering, memperoleh informasi tentang Tara, dan memilih respons kepada Maran. | Maran, stimpack, jalur lembah. -1 Hati atau +1 stok medkit. |
| act1_05<br>Kuil dan Pasupati | Melewati ancaman Utusan Kala, menghindari serangan, mencapai altar, mencabut keris, dan melakukan finisher. | Koridor retak, Utusan, altar, Pasupati. Unlock melee dan layar Demo Clear. |

#### Rute bergabung kembali

Rute darat dan drainase menuju puzzle bendungan yang sama. Pemain yang mengintimidasi Ki Pranata menghadapi total 6 penjaga. Peta Lontar membantu pemain sopan melewati tiga simpang kanan–kiri–kanan melalui drainase. Perbedaan rute memengaruhi tantangan, tanpa menuntut dua akhir demo yang berbeda.

#### Syarat penyelesaian

Act 1 selesai setelah perubahan bendungan membuka jalan 2150, interaksi Maran tuntas, dan Pasupati diperoleh. Time-Switch, state puzzle, kondisi Hati/medkit, serta checkpoint harus tetap konsisten selama kedua rute. Demo Clear menampilkan rangkuman tujuan tercapai dan teaser pengembangan Act 2.


## 08  LEVEL

### Prototype inti dan rencana game penuh

#### Ruangan uji bendungan

Ruangan uji memuat satu anchor, sebuah rintangan danau pada 2150, petunjuk scan, dan katup pada 682 M. Sabuk sudah aktif untuk kebutuhan pengujian. Pemain harus mengamati rintangan, membaca penyebab, berpindah era, mengubah katup, kembali, dan menyeberang. Semua langkah dapat diuji sebelum cutscene serta rangkaian cerita selesai.

| Kriteria prototype | Hasil yang harus dapat diuji |
| --- | --- |
| Gerak dan interaksi | Pemain dapat mencapai objek serta menerima prompt yang sesuai. |
| Dua era | Q bekerja pada anchor dan menolak tujuan yang terhalang. |
| Kausalitas | Katup mengubah keadaan danau di masa depan. |
| Checkpoint | Kegagalan dan restart tidak merusak state atau membuat puzzle buntu. |
| Keterbacaan | Playtester memahami tujuan dan hubungan dua era melalui petunjuk. |

#### Rencana level di luar demo

| Bagian | Rancangan dan progresi |
| --- | --- |
| Act 2<br>Rimba Kausalitas & Sang Pengamat | Padjadjaran dan Majapahit beserta pasangan lokasi 2150. Puzzle beringin silika, fasilitas geotermal, kanal, konflik Tara Half-Vessel, Kunta dan Cakra. Rencana 10 scene; beberapa adegan masih dalam pengembangan naskah. |
| Act 3<br>The Temporal Sanctum | Mataram Kuno, pemurnian altar, Tara Full Vessel, pemutusan benang waktu, dan pertarungan akar Kala. Rencana 2 scene utama. |
| Epilog<br>The Bittersweet Reset | Garis waktu 2150 pulih. Tara hidup normal; Saka tetap hidup namun tidak dikenali. Satu rangkaian penutup. |

Rencana game penuh memperlihatkan arah progresi, bukan kewajiban konten yang harus selesai pada demo. Produksi tiap bagian dimulai setelah milestone sebelumnya dapat dimainkan dan diuji.


## 09  USER INTERFACE

### Menu, HUD, dan bantuan

UI memakai tipografi yang mudah dibaca di atas dunia pixel art. Angka, teks, pilihan, dan progress dibuat sebagai elemen UI fungsional, sehingga perubahan bahasa atau nilai tidak memerlukan penggambaran ulang sprite.

[Diagram: wireframe]

| Komponen | Informasi dan interaksi |
| --- | --- |
| Menu utama | Rancangan Mulai, Pengaturan, Kredit, dan Keluar. Continue ditambahkan setelah penyimpanan antarsesi tersedia. |
| HUD gameplay | 5 node Hati, 3 slot medkit, era aktif, dan prompt objek terdekat. Informasi hanya tampil ketika relevan. |
| Dialog | Nama, portrait, teks, pilihan jawaban, dan petunjuk konfirmasi. Gerak dan serangan dikunci selama dialog modal. |
| QTE | Jarum timing, zona target, tombol konfirmasi, dan feedback sukses/gagal. |
| Scan dan peta | Petunjuk objek dalam teks ringkas; Peta Lontar menampilkan rute simpang saat dimiliki. |
| Pause / pengaturan | Volume master, musik, dan SFX; petunjuk kontrol; restart checkpoint; kembali ke menu utama. |

#### Camera dan help system

Kamera menjaga jalur depan serta objek tujuan terlihat, berhenti pada batas scene, dan tidak bergerak saat modal membutuhkan fokus. Tutorial menunjukkan input secara kontekstual. Pemain dapat membaca ulang kontrol melalui menu bantuan. Teks dan ikon mendampingi warna untuk alarm, anchor, serta status QTE.

#### Audio interface

Pengaturan volume memisahkan master, BGM, dan SFX. Subtitle/teks dialog menyampaikan informasi cerita. Petunjuk wajib tetap terlihat tanpa audio; suara menambah feedback, bukan satu-satunya cara mengetahui tujuan.


## 10  TIMELINE

### Jadwal produksi

Minggu awal proyek dihitung dari asistensi pertama pada 18 September 2026. Minggu 1–3 merupakan riwayat aktivitas tim; minggu 4 adalah tahap prototype yang sedang berjalan. Minggu 5–9 menunjukkan rencana lanjutan dan dapat disesuaikan dengan jadwal UAS.

[Diagram: gantt]

| Minggu | Tanggal | Fokus dan hasil |
| --- | --- | --- |
| M1 | 18–24 Sep | Asistensi pertama dan pembahasan GDD awal. |
| M2 | 25 Sep–1 Okt | Eksplorasi aset dan brainstorming konten. |
| M3 | 2–8 Okt | Penyusunan storyline dan asset guide. |
| M4 | 9–15 Okt | Percobaan prototype; finalisasi GDD/PPT untuk pengumpulan UTS. |
| M5 | 16–22 Okt | Rencana: puzzle dua era, anchor, kausalitas, checkpoint, dan playtest inti. |
| M6 | 23–29 Okt | Rencana: produksi pixel art final tim serta integrasi Prolog. |
| M7 | 30 Okt–5 Nov | Rencana: stealth, dialog Ki Pranata, drainase, dan bendungan Act 1. |
| M8 | 6–12 Nov | Rencana: Maran, kuil, Pasupati, HUD, dan audio. |
| M9 | 13–19 Nov | Rencana: playtest penuh, perbaikan, ekspor Windows, dan itch.io. |

#### Urutan dependensi

Mekanik puzzle dan checkpoint diuji sebelum memperluas scene. Produksi aset mengikuti layout yang sudah dapat dimainkan. Integrasi cerita mempergunakan flag dan kontrol kontekstual yang stabil. QA akhir menilai kedua rute, kondisi sukses/gagal, durasi, dan build ekspor.


## 11  TEAM DESCRIPTIONS

### Tim Arunika Studio

| Anggota / NIM | Peran | Tanggung jawab |
| --- | --- | --- |
| Marvin Karyanda<br>123140185 | Game Designer<br>Programmer<br>Tester | Menjaga GDD, merancang puzzle/level, mengimplementasikan sistem gameplay dan integrasi Godot, serta menguji build. |
| Muhamad Arif Ardani<br>123140186 | Illustrator<br>Sound Engineer<br>Tester | Memproduksi pixel art final, menjaga palet dan animasi, mengolah SFX/BGM bersama tim, dan menguji keterbacaan visual/audio. |
| Falent Antonius Panjaitan<br>123140124 | Programmer<br>Sound Engineer<br>Tester | Mengimplementasikan fitur sesuai pembagian tugas, mengintegrasikan audio, serta menguji kontrol, progresi, dan stabilitas build. |

#### Pembagian kerja

Game Designer menyiapkan tujuan scene, aturan, dan kriteria selesai. Programmer membuat versi playable serta state yang dapat diuji. Illustrator memproduksi sprite/prop/background berdasarkan layout dan gaya yang disepakati. Sound Engineer menyiapkan audio sesuai suasana dan aksi. Semua anggota melakukan playtest serta mencatat bug.

#### Siklus integrasi

Setiap scene melalui brief, implementasi, review aset, integrasi, dan playtest. Tim memeriksa apakah tujuan jelas, kontrol bekerja, state tersimpan, dan rute sukses/gagal dapat diulang. Perubahan lore atau ending dibahas bersama; perubahan parameter dicatat agar GDD dan build tetap sinkron.

#### Dokumen proyek

GDD menjadi acuan mekanik serta scope. Story Document menyimpan dialog dan cutscene lengkap. Asset Guide menyimpan palet, ukuran, animasi, format ekspor, dan sumber aset. Ketiganya diperbarui ketika keputusan produksi berubah.

#### Kriteria build untuk pengumpulan

Build Windows dapat dibuka dan dimainkan melalui keyboard, dapat diselesaikan sedikitnya 5 menit, menghadirkan minimal tiga jenis konten unik, dan tersedia di itch.io. Aset final serta penggunaan kode mengikuti ketentuan tugas. Pengujian dilakukan pada build hasil ekspor, bukan hanya di editor.


## REFERENSI

### Sumber dan acuan visual

Dokumen mengikuti struktur TEMPLATE Game Design Document Teknik Informatika ITERA v1.2. Konsep, karakter, mekanik, dan cerita berasal dari dokumen kerja KALA milik Arunika Studio. Riwayat minggu pengerjaan mengikuti keterangan tim pada 10 Oktober 2026.

#### Dokumen internal

GDD_FINAL.md — aturan gameplay, progresi, dan scope produksi. STORY_FINAL.md — naskah cerita dan dialog. KALA_ASSET.md — spesifikasi visual dan inventaris rencana produksi. Arah visual pada dokumen pengumpulan ini adalah 2D pixel art.

#### R1  Tales of the Neon Sea

Halaman game resmi di Steam. Referensi detail lingkungan pixel dan pencahayaan kota futuristik. Screenshot digunakan sebagai moodboard dengan hak cipta tetap pada pemilik game.

https://store.steampowered.com/app/828740/Tales_of_the_Neon_Sea/

#### R2  A Space for the Unbound

Halaman game resmi di Steam. Referensi ekspresi karakter, suasana Indonesia, dan penyampaian cerita melalui pixel art. Screenshot digunakan sebagai moodboard dengan hak cipta tetap pada pemilik game.

https://store.steampowered.com/app/1201270/A_Space_for_the_Unbound/

#### R3  Cyberpunk 2077

Halaman game resmi di Steam. Referensi atmosfer teknologi, material industrial, dan pencahayaan. Unsur visual ditafsirkan untuk game 2D KALA; screenshot tidak menjadi aset gameplay.

https://store.steampowered.com/app/1091500/Cyberpunk_2077/

#### Acuan tugas

Tek Game 26–27 — Aturan Tubes: tema Sains Fiksi Nusantara, batas prototype, keyboard, Windows/Web, dan publikasi itch.io. GDD dan materi presentasi disiapkan dalam PDF. Referensi visual diakses 10 Oktober 2026.
