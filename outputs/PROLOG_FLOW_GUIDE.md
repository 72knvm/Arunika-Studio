# Alur latar kamar → jembatan → kedai

Main scene F5 untuk tes saat ini: `scenes/prolog/bridge_to_kedai_test.tscn` (mulai langsung di bridge).
Alur lengkap dari kamar: buka `scenes/prolog/prolog_flow.tscn`, lalu F6.
Controller alur: `scripts/prolog/prolog_flow.gd`.

Revisi aktif pemisahan kedai: lihat `outputs/BRIDGE_KEDAI_FLOW_GUIDE.md`. Bridge berakhir sebelum badan kedai; seluruh percakapan dan pilihan harus selesai sebelum fade ke `scenes/prolog/kedai_walk_scene.tscn`. Kedai memakai latar yang sama dan karakter berdiri. Catatan verifikasi ukuran/rute terdahulu di bawah adalah riwayat, bukan ukuran jalur terbaru.

## Fullscreen

F11 atau Alt+Enter berganti antara fullscreen dan jendela. Ukuran dan posisi jendela dipulihkan setelah keluar fullscreen. Shortcut berlaku juga pada scene uji F6; Alt+Enter tidak memajukan dialog.

Resolusi dasar tetap1672×941, dengan canvas_items dan stretch aspect keep. Aset, karakter, kamera, dan UI diskalakan bersama tanpa mengubah proporsi atau area permainan. Monitor dengan rasio berbeda mendapat bidang hitam di sisi yang tersisa.

Saat mengetes dari editor, hentikan game dengan F8, lalu pilih mode **jendela tanpa toolbar** pada tab Game sebelum F5. Godot4.7 menyediakan tombol dengan tooltip "Run the game in a floating window without the toolbar on the next run." Jendela terpisah yang masih memiliki toolbar Godot tetap embedded dan tidak mendukung fullscreen. Shortcut mengecek Engine.is_embedded_in_editor() dan tidak mengubah mode saat embedded; petunjuk dicetak satu kali di Output. Pengaturan embedding editor tidak ikut ke build game.

## Cara mencoba

1. Untuk alur lengkap, buka `scenes/prolog/prolog_flow.tscn`, lalu F6. Pembuka fade masuk ke kamar: Saka tidur dan Tara membangunkan. F5 saat ini langsung mulai pada langkah6 untuk tes bridge → kedai.
2. E / Space / Enter atau klik kiri: tampilkan teks yang masih mengetik; tekan lagi untuk lanjut. Lima ucapan dari pro_01 dibagi menjadi12 halaman pendek, umumnya1–2 baris dengan teks40px. Gerakan dan pintu dikunci saat dialog. Saka tetap berbaring selama halaman Tara “Udah mau jam delapan!” ditampilkan. Setelah pemain melanjutkan dari halaman itu, Saka bangun melalui fade cepat dan sentakan kecil, lalu kalimat Tara berikutnya muncul. Klik untuk menyelesaikan efek mengetik belum memicu bangun.
3. Setelah dialog selesai, Saka bisa berjalan dan Tara mengikuti di kamar.
4. Berjalan ke kanan dengan D atau panah kanan. Di dekat pintu, petunjuk berubah menjadi **E: Keluar ke jembatan**.
5. Tekan E. Layar fade ke hitam lalu membuka jembatan, dengan Saka muncul di sisi kiri.
6. Berjalan di jembatan menggunakan A/D atau panah. Langit/laut/kota bergerak bersama dengan batas120px. Balon pertama muncul setelah berjalan ke kanan sekitar450px atau2.5detik. Balon mengikuti pembicara; ketikan dan pergantian halaman sepenuhnya otomatis, tidak bisa dipercepat oleh Space/klik/Enter/E. Selama balon aktif, Saka tetap bisa berjalan. Setelah Tara menyelesaikan pertanyaan kode brankas, Saka dan Tara berhenti dan saling menghadap. Pilih **1: Rahasiakan pesan Kakek** atau **2: Jelaskan catatan Kakek**, dengan tombol angka, klik, atau panah kiri/kanan lalu Enter. Saka menjawab dan Tara membalas melalui textbox manual E/Space/Enter/klik. Setelah seluruh halaman selesai, gerakan dibuka dan balon terakhir lanjut sesuai jarak. Panjang jalur tetap sekitar1menit berjalan; waktu memilih/membaca textbox menambah durasi bermain tanpa menambah panjang jembatan. Set visual kedai sudah terpasang di ujung; interaksi duduk dan dialog sarapan belum dihubungkan.
7. Untuk mengulang tes, kembali ke pangkal kiri jembatan lalu tekan E saat muncul **E: Kembali ke kamar**. Kamar dimulai lagi dari posisi awal tanpa mengulang dialog. F8 lalu F5 mengulang pembuka.

Main Scene untuk tes sambungan adalah `scenes/prolog/bridge_to_kedai_test.tscn`. Scene kamar, bridge dan kedai tetap bisa dibuka sendiri melalui F6; preview bridge sendiri tidak menjalankan controller perpindahan lokasi.

## Perilaku

Alur memakai scene dan aset kamar/jembatan yang sudah ada. Controller alur mengelola input, menyembunyikan panel uji, serta menonaktifkan kontrol debug scene selama alur berjalan. E berfungsi untuk pintu dan tidak menggeser latar kamar.

Transisi memakai fade 0.35 detik keluar dan 0.35 detik masuk. Gerakan dan interaksi dikunci selama fade, sehingga penekanan E berulang tidak memuat scene ganda. Scene lama dilepas sebelum scene berikutnya dipasang. Kamera jembatan direset ketika kembali ke kamar.

Pintu kamar berada pada x1480, radius interaksi 100px. Pangkal kembali di jembatan berada pada x180 dengan radius yang sama; Saka masuk jembatan pada x440 dan Tara pada x220, kaki keduanya y870 pada lantai cyberpunk baru. Titik masuk digeser agar kedua karakter terlihat utuh. Perpindahan ini merupakan sambungan latar langsung lewat fade; belum ada scene lorong atau eksterior apartemen.

Tara kini hadir di kamar dan jembatan. Saat pembuka dia menghadap kasur; sesudah Saka bangun keduanya saling menghadap. Setelah dialog, Tara mengikuti dengan controller yang sama seperti bridge. Kedua karakter berhenti selama fade. Posisi kamar direset saat kembali; dialog pembuka hanya diputar sekali per run. Belum ada penyimpanan progres antarsesi.

Dialog tersimpan sebagai data terpisah di data/dialogue/pro_01_room.json. Wording lima ucapan dari STORY_FINAL.md dipertahankan dan dipecah menjadi12 halaman, dengan ID utterance untuk mengelompokkan ucapan asli. Cue bangun disimpan pada data on_advance:wake_saka, sehingga dipicu ketika pemain meninggalkan halaman tersebut. Textbox pengguna dipasang sebagai Control/TextureRect dan teks Godot terpisah; nama42px, rata tengah pada pelat nama, isi40px, hint24px. Portrait emosi, alarm/SFX, animasi bangun khusus dan tutorial pemindai F belum dimasukkan. Pergantian tidur–idle menggunakan fade0.10detik per arah dan sentakan16px yang kembali ke baseline dalam0.18detik.

Pilihan brankas memakai data/dialogue/pro_02_bridge_choice.json dan UI scenes/ui/dialogue_choice.tscn dengan skin textbox yang sama. on_finish:grandpa_safe pada ucapan ketiga memicu pilihan setelah halaman terakhir selesai otomatis. Scheduler balon berhenti selama pilihan/textbox, lalu melanjutkan antrean dengan jeda 3 detik setelah jawaban selesai dan kamera kembali normal. Wording asli Saka/Tara dipertahankan: pilihan A dibagi6halaman, pilihan B7halaman. grandpa_safe_choice menyimpan ID protective/honest selama run; pilihan yang selesai tidak muncul ulang saat kembali ke bridge. Restart F5 mereset pilihan. Efek Emotional Echo/buff Act2 belum diimplementasikan.

Saat percakapan brankas dimulai, kamera mendekat1.25× dan memusatkan Saka/Tara selama0.45detik sebelum pilihan ditampilkan. Posisi vertikal diatur agar kepala sampai kaki terlihat di atas badan textbox; pasangan berada di tengah sehingga pelat nama di kiri tidak menutup Tara. Textbox berada di CanvasLayer dan ukurannya tetap. Setelah halaman terakhir, textbox disembunyikan dan kamera kembali ke posisi jalan sebelumnya dengan zoom1× dalam0.45detik. Gerakan, pintu, dan scheduler balon tetap terkunci selama kedua transisi kamera. Posisi karakter tidak dipindahkan untuk framing.

Kedai Mak Inah kini terpasang sebagai foreground tunggal di ujung jembatan, melalui scenes/prolog/kedai_set.tscn. Memakai kios + dua set meja/empat kursi transparan tanpa Saka/Tara duduk dari gambar. Langit/kota/laut, trotoar, jalur, dan batas gerak tetap dari scene bridge; kios tidak ikut tile dan bergerak bersama kamera seperti objek dunia lain. Saka/Tara tetap memakai sprite jalan yang ada. Empat Marker2D Seats/Chair1–Chair4 disiapkan untuk pilihan kursi nanti; interaksi E duduk dan dialog sarapan belum dihubungkan. Detail aset dan prompt berada di assets/sprites/backgrounds/prolog/kedai/kedai_set_v01.md.

## Verifikasi

Revisi ukuran/jarak kedai: furniture naik8.3% secara vertikal, celah antarmeja48px, jarak kursi terakhir ke kios tetangga sekitar60px. Kios Mak Inah dan neighbor row kini atlas terpisah supaya bisa diatur jaraknya tanpa menggambar ulang PNG. Kedai lebih awal194px di jalur karena row lebih lebar; durasi dialog/jalur dan kamera jalan tetap sama. work/verify_kedai_set.gd lulus untuk clearance kedua set dan neighbor row, ukuran kursi terhadap Saka, grounding, serta prop makanan yang tetap mengikuti meja.

Meja kedai dimulai kosong, tanpa lontong/minuman. Prop makanan sekarang satu Sprite2D terpisah, disembunyikan sampai serve_at_seat() dipanggil oleh interaksi duduk yang akan dipasang nanti. Index kursi0/1 menampilkan prop pada meja pertama;2/3 pada meja kedua. Input E duduk belum aktif. Verifikasi dan render kedua penempatan prop tercatat di assets/sprites/backgrounds/prolog/kedai/kedai_meal_v01.md.

work/verify_kedai_set.gd memeriksa alpha transparan, penggunaan layer latar asli, dasar kios/furnitur pada trotoar lama, seluruh row terlihat di ujung, empat titik kursi, serta posisi prop tetap di dunia saat kamera bergerak. Render Forward+/D3D12 diperiksa di outputs/kedai_approach_preview.png, outputs/kedai_walking_preview.png, dan outputs/kedai_empty_preview.png.

work/verify_bridge_choice.gd lulus untuk kedua cabang, pemicu sesudah pertanyaan selesai, pilihan lewat tombol angka/klik GUI, event memilih tidak melewati halaman pertama, karakter/kamera berhenti setelah framing, kepala/kaki kedua karakter di luar textbox, zoom tidak mengubah ukuran UI, semua halaman muat, advance manual, posisi/zoom kamera dipulihkan tanpa drift, follower/balon lanjut, dan pilihan diingat tanpa muncul ulang saat re-entry. work/verify_bridge_choice_text.py memastikan empat ucapan asli STORY_FINAL.md tidak berubah. Render pilihan dan jawaban diperiksa di outputs/bridge_choice_options.png, outputs/bridge_choice_protective.png, outputs/bridge_choice_honest.png, dan outputs/bridge_choice_camera_restored.png. Percabangan diuji melalui alur F5; preview F6 bridge tetap khusus latar, jalan, follower, dan balon otomatis.

`work/verify_bridge_floating.gd` lulus untuk input yang tidak bisa skip, antrean halaman, pergantian otomatis, teks muat, posisi panel/ekor terhadap pembicara dan kamera, gerak Saka/Tara saat berbicara, backtracking tanpa pengulangan, serta penghentian balon saat fade kembali ke kamar. `work/verify_bridge_pacing.gd` menguji seluruh perjalanan dan13halaman pada30/60fps: dialog selesai~56.3detik, ujung tercapai58.93detik dari spawn preview, dengan2.6–2.7detik sisa jalan. Rute11352px dengan batas kanan11172; F5 memakai spawn125px lebih awal sehingga total perjalanan~59.6detik. Pemain tidak perlu menunggu dialog di batas ujung. Render diperiksa di outputs/bridge_floating_tara.png, outputs/bridge_floating_saka.png, dan outputs/bridge_floating_end.png. Untuk tes cepat, buka scenes/prolog/bridge_layer_test.tscn lalu F6 dan berjalan ke kanan; R mengulang percakapan preview.

`work/verify_fullscreen.gd` lulus pada jendela Windows asli dengan Forward+/D3D12: fullscreen sesuai ukuran monitor, kembali ke posisi/ukuran sebelumnya, F11/Alt+Enter, repeat tombol diabaikan, Alt+Enter tidak memajukan dialog, dan layout tetap muat pada1280×720,1280×800,1400×600. Pembulatan area render ditoleransi sampai satu pixel fisik. Preview diperiksa di outputs/fullscreen_room.png, outputs/fullscreen_wide_room.png, dan outputs/fullscreen_bridge.png.

`work/verify_prolog_flow.gd` lulus untuk pose tidur, penguncian gerak/dialog, reveal lalu advance melalui input nyata, fade bangun, Tara di kamar, radius pintu, input E, penekanan berulang, spawn jembatan, kamera, dan kembali tanpa replay dialog. Render Forward+/D3D12 berhasil dan diperiksa pada:

- `outputs/prolog_flow_room.png`
- `outputs/prolog_flow_sleep_dialogue.png`
- `outputs/prolog_flow_eight_oclock.png`
- `outputs/prolog_flow_awake_dialogue.png`
- `outputs/prolog_flow_sleep_reply.png`
- `outputs/prolog_flow_long_dialogue.png`
- `outputs/prolog_flow_door.png`
- `outputs/prolog_flow_fade.png`
- `outputs/prolog_flow_bridge.png`
- `outputs/prolog_flow_room_return.png`

