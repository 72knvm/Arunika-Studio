# Bridge → Kedai Mak Inah

11 Oktober 2026. Kedai sekarang merupakan lokasi terpisah dari bridge.

## Menjalankan

- **F5**: alur penuh dari kamar. Tes langsung bridge: buka `scenes/prolog/bridge_to_kedai_test.tscn`, lalu F6. Jalan dengan D/panah kanan, selesaikan pilihan brankas dan textbox, lalu teruskan berjalan. Setelah seluruh balon otomatis selesai, mencapai titik masuk memicu fade menuju kedai.
- Tes langsung kursi/dialog sarapan: buka `scenes/prolog/kedai_dialogue_test.tscn`, lalu F6. Lihat `outputs/KEDAI_DIALOGUE_GUIDE.md`.
- Alur lengkap dari kamar: buka `scenes/prolog/prolog_flow.tscn`, lalu **F6**.
- Uji visual kedai saja: buka `scenes/prolog/kedai_walk_scene.tscn`, lalu **F6**.
- Preview bridge sendiri lewat F6 tetap menampilkan latar/balon dan batas masuk, tetapi perpindahan lokasi dikelola oleh controller alur pada tes F5.

## Perilaku

Jarak jalan bridge dihitung dari spawn, kecepatan Saka dan durasi percakapan otomatis. Seluruh 13 halaman selesai sebelum titik masuk dalam perjalanan normal, kemudian tersisa sekitar 2–3 detik berjalan. Waktu membaca pilihan dan textbox manual menambah durasi permainan tanpa menggerakkan karakter atau menambah jarak jalur.

Setelah jawaban brankas selesai dan kamera kembali normal, ada jeda 3 detik sebelum Tara membahas aroma lontong kari. Pemain dapat berjalan selama jeda; panjang jalur ikut menyesuaikan waktu tambahan ini.

Kedai mulai terlihat di depan menjelang akhir percakapan. Batas gerak bridge berhenti 220px sebelum badan kedai. Perpindahan hanya terjadi saat Saka berjalan ke kanan, sudah mencapai batas, dan percakapan otomatis serta interupsi sudah selesai. Jika tiba terlalu dini, balon tetap selesai otomatis tanpa dapat dilewati dengan input. Kedatangan dipicu sekali, sehingga menahan D tidak menghasilkan scene ganda.

Scene kedai tidak memiliki controller percakapan bridge. Saka dan Tara tiba berdiri, kedua meja kosong dan makanan tersembunyi. Kedai serta kursi memakai ukuran terakhir yang disetujui. E di kursi pilihan mendudukkan Saka dan Tara berhadapan, menampilkan makanan pada meja pilihan dan memulai 17 halaman dialog sarapan. Kalimat terakhir Tara terpotong oleh getaran layar otomatis 1.2 detik, disusul dua halaman reaksi Saka/Tara (total 19). Selama dialog/getaran, gerak serta akses kembali terkunci; setelah jawaban Tara selesai mereka berdiri menghadap jalan pulang dan kamera kembali normal.

Langit, kota, laut, pagar, lantai, lampu dan karakter memakai scene dasar bersama `waterfront_walk_scene.tscn`. Saat masuk kedai, controller membawa offset dunia, jarak Tara terhadap Saka dan pergeseran backdrop. Posisi layar karakter/kedai, pola lantai yang dimirror dan lampu tetap sesuai lokasi sebelumnya. Fade 0.35 detik keluar dan 0.35 detik masuk mengunci gerak selama perpindahan.

Setelah dialog sarapan/getaran selesai, di pangkal kiri kedai E masuk ke jembatan fase kabur (`ESCAPE`), bukan jalur percakapan pagi. Bridge awal utuh selama 1.5 detik lalu kilatan putih memasang panorama dan collision rusak. Percakapan pagi serta jawaban brankas tidak diulang. Detail kontrol, checkpoint, aset sementara dan batas fase ada di `outputs/BRIDGE_ESCAPE_GUIDE.md`.

## File utama

- `scripts/prolog/waterfront_walk_scene.gd`: geometri bersama, kamera, interpolasi, parallax dan gerakan.
- `scripts/prolog/bridge_layer_test.gd`: percakapan bridge, penempatan preview kedai dan batas masuk.
- `scripts/prolog/kedai_walk_scene.gd`: lokasi kedai dan ruang berjalan di area makan.
- `scripts/prolog/prolog_flow.gd`: lokasi ROOM/BRIDGE/KEDAI/ESCAPE, input, pilihan dan transisi.
- `scripts/prolog/bridge_escape_scene.gd` dan `escape_actor.gd`: kilatan, layout rusak, gerak fisika, slide/jump, companion dan checkpoint.
- `scripts/prolog/bridge_walk_dialogue.gd`: penjadwalan halaman, status selesai dan pengembalian tanpa replay.

## Verifikasi

`work/verify_bridge_kedai_flow.gd` lulus pada simulasi 30/60/120 FPS: 13 halaman berurutan, kedua cabang pilihan, 61.1 detik berjalan, 2.6–2.8 detik setelah dialog otomatis, perpindahan ke scene terpisah, kesinambungan posisi/pola lantai/backdrop, kedatangan berdiri, gerak follower di kedai dan kembali tanpa replay. Kasus tiba terlalu awal tetap tertahan sebelum kedai sampai dialog selesai, lalu hanya memicu satu kedatangan.

Bagian return pada tes tersebut memakai flag sarapan selesai tanpa getaran sebagai tes regresi jalur lama. Alur cerita aktual setelah getaran dites oleh `verify_kedai_dialogue.gd` (keempat kursi → ESCAPE) dan `verify_bridge_escape.gd` (flash, rintangan, lompat, checkpoint dan Tara).

Tes lama untuk kamar, pilihan bridge, pacing, balon otomatis, geometri bridge dan prop kedai juga lulus. Capture grafis Forward+/D3D12 diperiksa:

- `outputs/bridge_kedai_approach.png`
- `outputs/kedai_scene_arrival.png`
- `outputs/kedai_scene_dining.png`
