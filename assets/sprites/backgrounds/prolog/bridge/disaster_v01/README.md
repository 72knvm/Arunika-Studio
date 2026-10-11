# Jembatan Astanapura 2150 — fase kabur, v01

Paket aset terpisah mengikuti jembatan `cyberpunk_v01`: bentuk sederhana, garis gelap, baja indigo, kaca cyan, reklame magenta/biru, dan pencahayaan badai ungu. Tanpa karakter. Ada 13 PNG sumber dan 19 aset yang dapat dipilih: 3 layer latar, 7 bagian jembatan/rintangan, dan 9 puing.

Tambahan untuk ide puing terlempar: dua PNG sederhana bagi QTE slide dan lompat. Lihat [QTE_DEBRIS_v01.md](QTE_DEBRIS_v01.md) serta `qte_debris_preview_v01.tscn`. Ini tambahan di luar 13 PNG paket awal.

## Isi paket

| Kategori | PNG sumber | Resource untuk pemasangan |
| --- | --- | --- |
| Langit setelah anomali | [Langit](bg_pro_03_sky_t0_v01.png) | PNG langsung; 1672 × 941, opaque |
| Kota hancur | [Kota](bg_pro_03_city_t2_v01.png) | `bg_pro_03_city_t2_v01.tres` |
| Laut setelah bencana | [Laut](bg_pro_03_sea_t1_v01.png) | `bg_pro_03_sea_t1_v01.tres` |
| Lantai rusak berulang | [Lantai](prop_pro_03_floor_repeat_v01.png) | `prop_pro_03_floor_repeat_v01.tres` |
| Tepi amblas kiri/kanan | [Kiri](prop_pro_03_chasm_edge_left_v01.png), [kanan](prop_pro_03_chasm_edge_right_v01.png) | Pakai dua `.tscn` dengan nama yang sama; AtlasTexture dan material sambungannya sudah terpasang |
| Pagar rusak | [Pagar](prop_pro_03_rail_broken_v01.png) | `prop_pro_03_rail_broken_v01.tres` |
| Reklame untuk slide | [Reklame](prop_pro_03_billboard_slide_v01.png) | `prop_pro_03_billboard_slide_v01.tres` |
| Lampu rusak | [Miring](prop_pro_03_lamp_leaning_v01.png), [patah](prop_pro_03_lamp_snapped_v01.png) | Dua `.tres` dengan nama yang sama |
| Puing kecil | [Beton](prop_pro_03_debris_concrete_sheet_v01.png), [kaca](prop_pro_03_debris_glass_sheet_v01.png), [logam](prop_pro_03_debris_metal_sheet_v01.png) | Tiga `.tres` per material: `prop_pro_03_debris_{material}_01_v01.tres` sampai `_03_v01.tres` |

Semua PNG selain langit mempunyai alpha transparan. Resource AtlasTexture membuang padding atau memilih bagian yang dibutuhkan tanpa mengubah PNG asli. Kaca hasil generator berwarna cyan opaque pada bidangnya; shader `disaster_glass.gdshader` memberikan transparansi kaca saat ditampilkan, termasuk pada pagar.

## Preview

Buka [bridge_disaster_assets_preview.tscn](bridge_disaster_assets_preview.tscn) lalu jalankan scene dengan F6. A/D atau panah kiri/kanan menggeser kamera untuk melihat parallax; R mengembalikan posisi awal. Scene ini hanya untuk meninjau aset, tanpa karakter atau collision gameplay. Tangkapan gabungan tersimpan di `outputs/bridge_disaster_assets_v01.png` pada root project.

Langit, laut, dan kota menggunakan node Parallax2D terpisah. Langit memakai scroll_scale.x 0.01; kota dan laut 0.025 agar pantulan tetap mengikuti kota. Lantai dan objek mengikuti kamera pada skala dunia 1.0. Rasio itu mengikuti kebutuhan kontinuitas scene yang sudah ada; bisa diubah saat merancang rute.

## Ukuran dan posisi

Pakai Texture Filter **Nearest**. Angka lengkap, region, serta ukuran tampilan tiap aset tersedia dalam [manifest.json](manifest.json).

| Patokan | Nilai pada canvas 1672 × 941 |
| --- | --- |
| Horizon sumber laut | y=578, sama dengan konstanta scene lama |
| Awal laut saat pemasangan | y=554 untuk overlap garis pantai, mengikuti scene lama |
| Kota | Region sumber setinggi 660 ditampilkan setinggi 612 untuk mengembalikan batas tepi air; PNG tetap 1672 × 941 |
| Awal lantai | y=832; tinggi segmen tampilan 109; lebar 384 |
| Garis kaki karakter saat berjalan | y=870 |
| Pagar | Bagian bawah y=832; tinggi tampilan 202 |
| Lampu | Alas y=828; tinggi miring 610, patah 340 |
| Reklame | Ukuran tampilan 600 × 226; titik paling bawah y=715 |
| Ruang slide preview | 870−715=155 px; tinggi pose slide saat ini 132 px |

Kota mempertahankan kelompok gedung kiri–kanan, jalur maglev kiri, dan kedua reklame lama sebagai landmark. Kerusakan menggambar ulang kontur dan sebagian proporsi, sehingga bukan salinan piksel identik kota lama. Atlas dan skala tampilan mengembalikan garis tepi air yang sempat bergeser pada hasil generasi.

## Penyusunan lantai dan celah

Ulangi segmen lantai yang sama dengan **mirror horizontal bergantian**. Pada setiap sambungan, kedua sisi lalu memakai kolom piksel sumber yang sama. Pakai posisi integer dan hindari filtering linear. Preview memperlihatkan lantai berulang pada skala dunia yang digunakan project.

Tepi kiri adalah tepi bank kiri: sisi patahnya menghadap kanan. Tepi kanan mempunyai sisi patah menghadap kiri. Tempatkan keduanya pada awal lantai y=832 dan sisakan ruang kosong antara ujung patah. Jangan pasang segmen lantai atau pagar utuh di bawah ruang itu. Ukuran celah ditentukan oleh posisi node dan collider di Godot, bukan gambar lubang berwarna gelap. Ujung rebar serta beton yang menggantung adalah dekorasi, bukan permukaan pijakan.

Koreksi sambungan: gunakan `prop_pro_03_chasm_edge_left_v01.tscn` dan `prop_pro_03_chasm_edge_right_v01.tscn` untuk menampilkan tepi. Material `bridge_edge_join.gdshader` menyelaraskan bidang atas, garis curb, dan muka depan dengan lantai 109 px, lalu menggunakan tekstur lantai yang sama pada 64 px terdekat ke sambungan. Hasilnya tidak mempunyai lompatan garis atau pergantian warna mendadak seperti preview pertama. PNG sumber tetap disimpan utuh; koreksi ini diterapkan saat render di Godot.

Jika memindahkan tepi ke rute lain, cocokkan `floor_phase_at_join` pada material dengan posisi pola lantai di sambungan, dalam siklus 768 px (dua tile 384 px dengan mirror bergantian). Nilai kiri pada preview adalah 600; nilai kanan 0 karena lantai berikutnya mulai tepat setelah tepi kanan. Pakai ukuran tampilan bawaan dan letakkan root scene pada y832. Material lokal per instance supaya penyesuaian satu tepi tidak mengubah tepi lainnya.

Reklame dan pagar dipasang sebagai objek terpisah. Untuk collision slide, gambar contour frame reklame setelah menentukan posisi dan skala; gunakan frame atas sebagai penghalang, dan biarkan bagian bawah terbuka. Collider dan keberhasilan manuver perlu diperiksa pada scene gameplay setelah pemasangan. Angka clearance di atas memeriksa ruang visual, bukan hasil playtest collision.

## Verifikasi dan sumber

Semua PNG telah diperiksa dimensinya dan alpha-nya; seluruh region AtlasTexture berada dalam gambar sumber. Preview dirender di Godot 4.7.2. Pergeseran kamera 110 px diperiksa terhadap transform layer: langit 1.1 px, laut/kota 2.75 px, foreground 110 px.

Metode: **built-in imagegen**, satu permintaan per kategori/objek, dengan referensi lokal jembatan yang disetujui. [PROMPTS.md](PROMPTS.md) menyimpan seluruh prompt dan koreksi. PNG tidak dipotong, diwarnai ulang, atau dimodifikasi lewat script. Script pembangun resource hanya menulis metadata, AtlasTexture, dan scene preview.

Status: aset AI v01 untuk review/placeholder sesuai catatan project. Paket tersimpan di project dan siap disusun; scene gameplay lama, shader bencana lama, serta collision fase kabur belum diganti.
