# Interaksi kursi dan dialog sarapan

Tes langsung kedai: buka `scenes/prolog/kedai_dialogue_test.tscn` lalu F6. F5 saat ini menjalankan alur penuh dari kamar. Tes khusus bridge → kedai tetap tersedia melalui F6 pada `bridge_to_kedai_test.tscn`.

1. Kedatangan masih berdiri, makanan tersembunyi, akses kembali ke jembatan terkunci.
2. Dekati salah satu dari empat kursi pada dua meja. Dalam radius 72px, popup E di atas Saka bertuliskan “Duduk” dan memilih kursi terdekat.
3. Tekan E: Saka duduk di kursi pilihan, Tara otomatis menempati kursi di seberangnya pada meja yang sama. Makanan muncul hanya pada meja tersebut.
4. Kamera mendekat 1.35× dan menempatkan kedua karakter utuh di atas textbox. Dialog berasal dari STORY_FINAL bagian B pro_02, dipisah menjadi 17 halaman pendek tanpa mengubah urutan percakapan.
5. E/Space/Enter atau klik kiri membuka teks, kemudian menekan lagi melanjutkan halaman. Input E saat duduk tidak melewati halaman pertama. Gerak dan akses keluar tetap terkunci sepanjang percakapan.
6. Begitu teks Tara mencapai “habis ini Kakak temenin aku ke—”, textbox menghilang dan panorama bergetar selama 1.2 detik, dengan kekuatan yang mereda. Pemain tetap terkunci dan tidak bisa melewati getaran. Kamera serta layer langit/laut/kota bergerak searah, lalu kembali tepat ke posisi semula.
7. Masih duduk, Saka mengatakan “Sial, ada apa ini? Kita harus pulang sekarang.” lalu Tara menjawab “Iya, Kak.” Dua halaman ini memakai kontrol textbox biasa. Total sekarang 19 halaman.
8. Setelah pemain menyelesaikan jawaban Tara, kedua karakter berdiri menghadap kiri, kamera kembali normal dan pemain bisa berjalan ke sisi kiri kedai untuk memakai E: Kembali ke jembatan. Tara mengikuti dari belakang, termasuk setelah tiba di jembatan.

Status selesai dipertahankan selama run. Setelah getaran kedai, E kembali ke jembatan sekarang masuk ke fase kabur pro_03: panorama awal utuh selama 1.5 detik, kilatan putih, panorama/jalur rusak, dialog darurat, kemudian sprint/slide/jump. Adegan Tara terangkat belum dipasang. Detail ada di `outputs/BRIDGE_ESCAPE_GUIDE.md`. Pemicu getaran `on_reveal: kedai_tremor` ada di JSON, jadi bekerja baik ketika teks selesai mengetik maupun ketika pemain membuka teks langsung.

Pose duduk memakai cutout generatif sementara. Detail proses dan prompt ada di `assets/sprites/characters/seated_pair_v01.md`. Kios, furnitur dan panorama tetap memakai aset yang sudah disetujui.

Fondasi trotoar memakai perpanjangan piksel tepi bawah aset lantai yang sama, agar laut tidak terlihat di bawah lantai ketika textbox menghilang pada kamera duduk.

`work/verify_kedai_dialogue.gd` memeriksa keempat kursi melalui input E, pasangan/meja, makanan, iris Saka, kamera, 19 halaman, getaran otomatis melalui typing/reveal, keselarasan layer, penguncian input selama getaran, dua reaksi masih duduk, baru berdiri setelah jawaban Tara, arah pulang dan kembali tanpa replay. Capture sambungan: `work/capture_kedai_tremor.gd` → `outputs/kedai_tremor.png`, `kedai_tremor_saka.png`, `kedai_tremor_tara.png`, `kedai_return_home.png`.
