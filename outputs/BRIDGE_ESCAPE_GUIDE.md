# Tes fase kabur jembatan

Keputusan user: getaran di kedai → berjalan pulang → jembatan awal masih normal → setelah 1–2 detik kilatan putih → panorama dan jalur rusak → mulai alur pro_03. Implementasi memakai jeda 1.5 detik setelah pemain mendapat kontrol di jembatan, bukan perubahan warna bertahap selama perjalanan.

## Menjalankan

- Tes langsung: buka `scenes/prolog/bridge_escape_test.tscn`, F6.
- Tes sambungan: F6 pada `kedai_dialogue_test.tscn`, pilih kursi, selesaikan sarapan/getaran/dua reaksi, berjalan ke kiri, tekan E untuk kembali ke jembatan.
- F5 tetap mulai dari kamar; main scene tidak diubah.

## Urutan dan kontrol

1. Jembatan normal selama 1.5 detik aktif. Gerak A/D masih tersedia.
2. Input gerak berhenti selama satu kilatan putih (0.08 detik masuk, 0.10 ditahan, 0.35 keluar). Kerusakan panorama/collision dipasang saat layar putih penuh.
3. Kamera mendekat untuk dua halaman dialog Saka dari pro_03: “Tara! Jembatannya mau runtuh!” dan “Pegang tangan Kakak erat-erat, lari sekarang!!”. Tombol dialog tidak sekaligus memicu lompat.
4. Kamera normal, kabur ke kiri: A/← gerak, tahan Shift sprint, tahan Ctrl/C slide, Space lompat. Kamera memberi ruang pandang ke kiri.
5. Reklame di x2980–3290 memblokir tubuh berdiri. Tubuh slide 132px muat pada ruang 155px di bawahnya; jika Ctrl dilepas di bawah reklame, karakter baru berdiri ketika ada ruang kepala.
6. Celah x1900–2180 kehilangan lantai collision. Sprint+jump menyeberanginya. Ada buffer lompat 0.12 detik dan coyote time 0.10 detik.
7. Tara mengikuti dari belakang dan otomatis slide/lompat. Target follow diarahkan ke lantai aman, tidak berhenti di tengah celah. Jatuhnya companion tidak memaksa retry pemain.
8. Jatuhnya Saka mengembalikan keduanya ke checkpoint lokal: sebelum reklame, sesudah reklame, atau sesudah celah. Kilatan/dialog tidak diputar ulang.
9. Sampai x1150, fase kabur berhenti. Adegan petir/Tara Maestro/penyelamatan belum diimplementasikan.

## Placeholder dan aset berikutnya

Sky/sea/city/deck/lamp memakai aset yang sudah disetujui. Shader sementara mengubah langit jadi ungu gelap dan menurunkan sebagian kolom gedung; ini belum aset kota hancur final. Reklame roboh serta tepi jurang adalah polygon sementara terpisah dari panorama.

Karakter tetap memakai sheet idle/walk yang disetujui. Sprint mempercepat animasi, pose udara memakai frame berjalan, dan pose slide memendekkan visual sementara agar collision dapat dites. Ini belum animasi lari/lompat/slide final; sprite asli tidak diedit. Pose menggandeng tangan belum ada. Audio bencana belum dipasang.

Aset final yang perlu disiapkan: langit anomali, kota hancur, reklame roboh, tepi lantai patah, Saka/Tara sprint/jump/slide. Layer transparan dan skala karakter/landmark harus mengikuti scene sekarang. Fase lanjutan memerlukan Tara Maestro, puing melayang, Saka meraih/terpental/terjatuh, liontin dan portal.

## Verifikasi

`work/verify_bridge_escape.gd`: jeda utuh 1.5 detik, kerusakan di balik flash, shader panorama, modal Space, perbedaan sprint, collision reklame, slide/headroom, gagal jurang dan checkpoint, sprint jump mendarat, Tara otomatis melompati jurang, serta batas akhir fase.

`work/verify_kedai_dialogue.gd`: semua kursi meneruskan 19 halaman/getaran/berdiri ke jembatan kabur yang awalnya utuh.

Capture `work/capture_bridge_escape.gd`: `outputs/escape_bridge_intact.png`, `escape_bridge_flash.png`, `escape_bridge_dialogue.png`, `escape_bridge_slide.png`, `escape_bridge_jump.png`.
