# Uji layer kamar Saka

Proyek sudah memakai scenes/prolog/room_layer_test.tscn sebagai main scene. Buka project.godot di Godot 4.7.2, lalu tekan F6 untuk scene yang sedang dibuka atau F5 untuk main scene.

- A/D atau panah kiri/kanan: berjalan sebagai Saka; lepas tombol untuk idle.
- Q/E atau slider: geser pemandangan jendela sedikit untuk memeriksa parallax.
- R: reset posisi Saka dan latar.
- 1–4: tampil/sembunyikan langit, kota, ruangan, dan furnitur.
- 5: tampil/sembunyikan Saka.
- F1: tampil/sembunyikan panel pemeriksaan.

Ruangan tidak looping. Furnitur dan dinding/lantai tetap selaras; hanya latar jendela bergeser. WindowClip membatasi exterior sehingga tidak muncul di luar kamar. Skala furnitur 0.94 dan offset langit +44 mengikuti paket layer v01.

Ini scene uji aset dengan Saka idle dan walk delapan frame dari satu set yang diseragamkan. Belum ada Tara, collision, dialog, pintu/brankas interaktif atau audio. Gambar pintu dan brankas masih menyatu dengan layer masing-masing. Panduan aktif dan prompt generasi tersedia di characters/SAKA_UNIFIED_GUIDE.md.

Dokumen desain disalin dari workspace lama ke docs/. Dokumen GDD/asset versi ini masih menyebut strategi demo yang lebih lama; arahan sesi terbaru memprioritaskan Prolog lengkap, tanpa batas lima menit, dengan deadline tiga hari dan gaya sederhana master v04.

Renderer Forward Plus/D3D12 yang dipilih pemilik proyek dipertahankan. Pemeriksaan otomatis boleh menggunakan override Compatibility saat renderer headless diperlukan. Viewport uji mengikuti ukuran asli layer 1672×941, ditampilkan dalam window 1152×648, dengan aspect keep. Ini belum standar logical pixel grid final.

## Verifikasi 9 Oktober 2026

- Godot 4.7.2 berhasil mengimpor keempat tekstur dan memuat main scene.
- Pemeriksaan headless lulus untuk dimensi tekstur, clipping, batas pergeseran positif/negatif, reset, serta posisi ruangan/furnitur yang tetap.
- Render grafis Compatibility berhasil disimpan sebagai room_layer_test.png dan diperiksa secara visual: furnitur berada di lantai dan exterior dibatasi pada jendela.
- Render Forward Plus/D3D12 juga berhasil dan diperiksa; screenshot terakhir memakai renderer asli proyek.
- Runtime pemeriksaan diarahkan ke work/godot-runtime agar tidak perlu menulis pengaturan editor ke luar workspace. Itu hanya environment proses uji, bukan perubahan pengaturan Windows pengguna.
