# Kedai Mak Inah — foreground kosong v01

Interaksi kursi kini dipasang pada controller prolog dan kedai_walk_scene. E memilih kursi terdekat, Saka–Tara duduk berhadapan, makanan muncul pada meja pilihan, dan akses kembali ke jembatan dibuka setelah seluruh dialog sarapan selesai. Lihat `outputs/KEDAI_DIALOGUE_GUIDE.md`; keterangan belum-terpasang di bawah merupakan riwayat aset.

Integrasi terbaru: foreground ini dipakai pada `scenes/prolog/kedai_walk_scene.tscn`, lokasi terpisah yang dimasuki sesudah dialog bridge selesai. Instance pada bridge hanya preview kedai di depan batas masuk; pemain tidak dapat melewatinya selama berada di bridge. Latar bersama dan kesinambungan posisi dibahas di `outputs/BRIDGE_KEDAI_FLOW_GUIDE.md`. F5 kini tes bridge → kedai; F6 pada prolog_flow menjalankan alur dari kamar.

Revisi proporsi terbaru (11 Oktober 2026): scale kios 0.80, naik 11.1% dari 0.72. Scale meja/kursi (0.552, 0.598), naik 15% dari (0.48, 0.52). Dasar kios tetap y=850 dan kaki furnitur tetap y=875. Celah antarmeja 48px; celah badan kedai ke kios tetangga 320px, menyisakan sekitar84px setelah kursi terakhir. Marker duduk serta ukuran/posisi makanan mengikuti ukuran furnitur. Lebar keseluruhan row1846.4px; kamera ujung memprioritaskan kedai utama dan kedua meja, sehingga kios tetangga dapat berlanjut melewati tepi kanan layar. Verifikasi kedai dan capture grafis lulus. Catatan ukuran di bawah adalah riwayat versi sebelumnya.

Revisi ukuran/jarak: meja dan kursi memakai scale(0.48,0.52), naik8.3% secara vertikal agar dudukan dan tabletop lebih sesuai dengan Saka380px. Kedua set memiliki celah48px. Kios Mak Inah dan deretan kios sebelah memakai dua atlas dari PNG kios yang sama: (47,47,940,699) dan(987,47,968,699), scale0.72. Row sebelah digeser sehingga ada gap250px dari badan Mak Inah, menyisakan sekitar60px setelah kursi terakhir. Area makan kedua berada di ruang samping Mak Inah, tanpa masuk ke konter tetangga. Lebar row sekarang1623.76px, margin kanan24px; bridge menempatkannya dengan ROW_WIDTH dan RIGHT_MARGIN. Metadata ukuran/lokasi v01 di bawah merupakan riwayat awal. Saka/Tara, trotoar, parallax dan panjang jalur tidak berubah.

Revisi prop makan: kedua meja runtime kini memakai atlas set kosong Rect2(1077,280,844,353). Bagian sumber meja kiri dengan makanan tidak dipakai lagi. Makanan dipisahkan ke kedai_meal_v01.png, tersembunyi secara default dan dapat ditampilkan pada meja pilihan melalui serve_at_seat(). Lihat kedai_meal_v01.md untuk kontrak pemilihan kursi, prompt, dan verifikasi. Input E/pose duduk masih belum terpasang.

11 Oktober 2026. Aset diturunkan dari lampiran pengguna menggunakan built-in image_gen dengan transparent_background=true. Kios dan furnitur dipisahkan, Saka/Tara yang sudah duduk di master dihapus, permukaan kios/kursi yang tertutup diisi ulang. Ini ekstraksi generatif dengan rekonstruksi, bukan crop piksel identik. PNG sumber disimpan utuh dan layer latar lama tidak diganti.

## File proyek

- `kedai_user_master_v01.png`: lampiran RGB 1672×941, SHA256 416E583ECF28BE7AE273D4A151D84F90C57F64E2B71A4D68CE9013E0EAC4101A.
- `kedai_kiosks_v01.png`: tiga kios berderet, RGBA 1998×787. Batas alpha≥128 (47,47)–(1955,746).
- `kedai_furniture_v01.png`: dua meja, empat kursi kosong, RGBA 2048×768. Set kiri dengan mangkuk/minuman: atlas (131,202,809,431). Set kanan kosong: atlas (1077,280,844,353).
- `scenes/prolog/kedai_set.tscn` dan `scripts/prolog/kedai_set.gd`: foreground yang dipakai scene bridge, tanpa sky/city/sea/floor atau karakter tambahan.

PNG generator disalin utuh dari direktori generated_images ke direktori aset ini; alpha asli dipertahankan. AtlasTexture menghilangkan padding, filter nearest dan shader alpha cutout0.5 menolak glow/halo samar. Steam pada gambar masih statis.

## Pemasangan

Satu row di x=route_length−ROW_WIDTH−60, lebar1373.76px. Scale kios0.72, dasar850; scale furnitur0.48, kaki875. Lantai asli832–941, kaki karakter jalan870. Tidak memperlebar trotoar, tidak menduplikasi kios sepanjang jalur, tidak mengganti panorama kota/laut/langit. Ukuran kios disesuaikan dengan tinggi karakter jalan380px.

Dua meja terlihat kosong dari karakter, dengan empat Marker2D Seats/Chair1–Chair4. Interaksi E dan pose duduk belum dipasang: penanda kursi menyiapkan pilihan sisi duduk Saka dan tempat pasang Tara di kursi pasangannya nanti. Tidak menambahkan dialog kedai atau tragedi.

F5: selesaikan kamar lalu berjalan ke kanan melewati percakapan brankas. Kedai muncul menjelang akhir jalur. F6 pada bridge_layer_test.tscn bisa dipakai untuk uji jalan/latar tanpa branch manual. Set kedai tidak perlu main scene baru.

## Verifikasi

work/verify_kedai_set.gd lulus: alpha, atlas, layer latar asli, baseline pada lantai, lokasi di ujung, row utuh pada kamera ujung, empat kursi, prop tetap di dunia, hanya karakter jalan yang ada. verify_bridge_pacing.gd, verify_bridge_choice.gd dan verify_prolog_flow.gd juga lulus. Capture Forward+/D3D12: outputs/kedai_approach_preview.png, outputs/kedai_walking_preview.png, outputs/kedai_empty_preview.png.

## Prompt kios — built-in image_gen

Input: kedai_user_master_v01.png, edit target; transparent_background=true.

```text
Use case: background-extraction / precise-object-edit. Input image is the EDIT TARGET for a Godot side-scrolling pixel art game. Produce a transparent cutout of ONLY the three adjacent food KIOSK BUILDINGS at the lower right: main navy/cyan LONTONG KARI MAK INAH booth, plus the two touching simple navy/amber booths on its right (rightmost is intentionally cropped at image edge). Preserve their design, dark outlines, low detail, exact amber sign text LONTONG KARI / MAK INAH, proportions, colors, curry pot, stacked bowls and cyan menu. Preserve main roof vent and bent pipe, and neighbor roof vents. REMOVE absolutely ALL characters, dining tables, chairs, sky, city, sea, bridge lamps, safety railing, pavement and shadows on pavement. Reconstruct the small portions of booth front/base that were hidden by characters/furniture with matching SIMPLE flat navy metal surfaces. No new details or people. The kiosk footprint bottoms share one horizontal baseline; fully include booth bases. This is one horizontally arranged contiguous booth-row asset on genuinely transparent RGBA, wide framing with minimal transparent padding, no background plane, ground, glow, halo, sheet labels or checkerboard. Do not duplicate the lamp above the kiosks. Only the row of food booths.
```

## Prompt furnitur — built-in image_gen

Input: kedai_user_master_v01.png, edit target; transparent_background=true.

```text
Use case: background-extraction / precise-object-edit. Input image is EDIT TARGET for KALA Godot game. Extract ONLY the TWO dining furniture sets from foreground lower-right: first rectangular orange-topped navy-metal table with its TWO chairs, second orange-topped navy table with its TWO empty chairs. Remove BOTH Saka and Tara entirely and restore the chair seat/back sections their bodies hid, matching the already visible empty chairs. Keep exactly TWO tables and FOUR separate chairs in total, two chairs flanking each table. Keep their low-detail pixel outlines, flat navy/purple metal, orange tabletops and seats, same side-view perspective and a single shared foot baseline. Preserve small bowls and drinks on the first table, but no people or hands. There must be a clear transparent GAP between the two table/chair sets so they can be sliced and positioned independently in Godot. Remove absolutely ALL kiosk structures, sky, sea, city, railing, lamps, pavement and cast ground shadows. All gaps under tables and between chair legs must be genuinely TRANSPARENT, not colored patches of floor. Full furniture legs intact. Wide landscape transparent RGBA canvas, minimal padding, two furniture groups side-by-side, each occupies one half. No backdrop, text, frame, labels, checkerboard, new props, extra furniture or people.
```
