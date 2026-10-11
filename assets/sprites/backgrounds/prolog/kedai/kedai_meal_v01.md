# Prop makanan kedai — layer terpisah

Revisi framing furnitur: meja/kursi kini scale(0.48,0.52), celah antarmeja48px. Baseline makanan kini734 (sebelumnya746) mengikuti tabletop yang naik. Prop tetap centered otomatis pada meja yang dipilih dan tidak tampil sebelum konfirmasi kursi.

11 Oktober 2026. Built-in image_gen mengekstrak dua mangkuk lontong, satu minuman dan uap dari lampiran codex-clipboard-745e5ac5-97f3-4eaf-bc5a-d1f6bcc15c8e.png. PNG generator disalin utuh sebagai kedai_meal_v01.png: RGBA2048×768; atlas alpha≥128 (488,146,1076,509). Ekstraksi generatif, bukan crop piksel identik.

## Runtime

Kedua meja pada kedai_set.tscn kini memakai area furnitur kosong yang sama: Rect2(1077,280,844,353) dari kedai_furniture_v01.png. Bagian furnitur sumber yang sudah berisi makanan tidak dipakai lagi. Meja dan kursi tetap tampil; mangkuk, minuman dan uap tidak ada sebelum pemilihan kursi.

Meal Sprite2D memakai scale0.16, baseline746 pada tabletop, atlas dan alpha cutout0.5. Node serta served_seat dimulai tersembunyi/−1. serve_at_seat(index) hanya dipanggil setelah tempat duduk dikonfirmasi: index0/1 memilih meja pertama,2/3 memilih meja kedua. Satu prop berpindah ke meja terpilih, sehingga makanan tidak muncul di kedua meja sekaligus. clear_meal() mengosongkan kembali kedua meja. Indeks di luar0–3 ditolak tanpa mengubah prop sebelumnya.

Pose duduk dan input E masih akan disambungkan pada tahap interaksi kursi; sekarang belum ada pemilihan kursi melalui gameplay. Fungsi pengaturan prop sudah diuji dan siap dipanggil controller tersebut. Tidak mengganti kios, panorama, lantai, jalur atau dialog.

## Verifikasi

work/verify_kedai_set.gd lulus: dua meja memakai atlas kosong, prop tersembunyi secara default, empat kemungkinan kursi memilih meja yang benar, indeks salah ditolak, reset kembali kosong, dan invariant latar/footing tetap lulus. Render diperiksa di outputs/kedai_empty_preview.png, outputs/kedai_meal_first_table_preview.png, outputs/kedai_meal_second_table_preview.png.

## Prompt built-in image_gen

referenced_image_paths: lampiran di atas; transparent_background=true.

```text
Use case: background-extraction / precise-object-edit. Input image is the EDIT TARGET, the approved KALA furniture sheet. Extract ONLY the food items from the LEFT dining table: two white/navy bowls of yellow-orange lontong curry with their small utensils, one orange iced-tea glass with straw between them, and the two simple pale steam wisps rising from the bowls. Keep the original arrangement: bowl LEFT, glass CENTER, bowl RIGHT, facing the player, as ONE standalone food-group sprite. Preserve low-detail pixel-art colors, dark outlines, silhouettes and relative proportions; no added detail. Remove ALL tables, chairs, tabletops, furniture legs, ground, cast shadows, people, scenery and backdrop. Reconstruct only the bottoms of the bowls if necessary so each bowl is complete and opaque. Truly transparent RGBA surrounding and between the items, no orange table-colored patch beneath them, no black rectangle, checkerboard or glow/halo. Use wide framing with minimal transparent padding, food group on shared horizontal baseline, complete straw and steam inside frame. No new items, labels, text or people. This will be a separate Sprite2D placed onto either empty game table only after a seat is selected.
```
