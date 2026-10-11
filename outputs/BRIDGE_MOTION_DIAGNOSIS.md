# Bridge motion check — 11 October 2026

Report: the entire view occasionally seems to pause while walking.

Confirmed issue: walking and camera positions changed at 60 physics ticks per second while the standalone game rendered at approximately 144 FPS. Physics interpolation was disabled. This produced repeated camera positions between movement updates.

The test did not reproduce a long frame stall. Embedded editor playback has not been profiled by this diagnostic, so occasional editor, driver or system stalls remain unconfirmed.

## Changes

- Enabled physics interpolation for the project; the existing room preview opts out to preserve its frame-driven background controls and waking animation.
- Character walking positions interpolate while individual sprite poses change immediately.
- Camera walking uses physics processing; cinematic dialogue camera tweens temporarily use frame processing, then restore interpolation.
- Spawning/resetting characters resets interpolation and immediately refreshes the camera.
- Screen-space bubble tails sample character movement after physics updates and follow the interpolated head position.

The renderer, assets, route length, movement speeds, dialogue timings and selected main scene remain as configured.

## Standalone measurements

Godot 4.7.2, Forward+/D3D12, RTX 3050 Laptop GPU, 1152×648 window, 144 Hz display. Each profile phase lasts 12 seconds; measurements exclude the first 2 seconds. Camera positions are sampled after rendering. Runs are sequential.

| Start-of-route sample | Interpolation off | Interpolation on |
| --- | ---: | ---: |
| Camera samples | 1440 | 1440 |
| Samples with unchanged camera position | 839 | 0 |
| Median camera displacement per frame | 0 px | 1.25 px |
| 95th percentile camera displacement | 3 px | 1.25 px |
| 95th percentile frame interval | 7.515 ms | 7.458 ms |
| Frames over 33.34 ms | 0 | 0 |

The destination sample also recorded zero repeated camera positions before the camera reached its world boundary. A stationary camera at that boundary is intentional.

## Verification

- `work/verify_bridge_interpolation.gd`: graphical test with physics reduced to 10 ticks per second; verifies continuous camera movement, immediate sprite poses, bubble tail alignment, cinematic camera restoration and spawn reset.
- `work/verify_bridge.gd`: geometry, camera bounds, character baselines and reset.
- `work/verify_prolog_flow.gd`: sleeping/waking cue, input, apartment/bridge transitions and return.
- `work/verify_bridge_choice.gd`: both choices, manual dialogue and camera framing/restoration.
- `work/verify_bridge_floating.gd`: automatic unskippable dialogue, movement, layout and cleanup.

Profiling script: `work/profile_bridge_motion.gd`. Optional user arguments `--no-interpolation` and `--single-phase` provide the comparison without changing the saved project setting.

Reference: [Godot jitter and stutter documentation](https://docs.godotengine.org/en/stable/tutorials/rendering/jitter_stutter.html).
