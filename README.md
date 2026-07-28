# caustic-sdl3

**SDL3 bindings for [Caustic](https://github.com/Caua726/Caustic) — windows, input, audio, rendering and the GPU API.**

![version](https://img.shields.io/badge/version-0.1.0-blue)
![modules](https://img.shields.io/badge/modules-21-lightgrey)
![sdl](https://img.shields.io/badge/SDL-3.x-orange)
![license](https://img.shields.io/badge/license-MIT-blue)

Twenty-one modules covering the parts of SDL3 a program actually reaches for:
window and display, the 2D renderer, surfaces and the software window-surface
path, the GPU API, events, keyboard, mouse, touch, gamepad, haptics, audio,
TrueType text, timers, clipboard, filesystem, message boxes and platform
queries.

These are direct `extern fn` declarations against the C ABI — no wrapper layer,
no allocation, no state of its own. You call SDL, from Caustic.

```cst
use "caustic-sdl3/init.cst"   as init;
use "caustic-sdl3/video.cst"  as video;
use "caustic-sdl3/events.cst" as events;

fn main() as i32 {
    init.init(init.INIT_VIDEO);
    let is *u8 as win = video.create_window("hello", 800, 600, 0);
    // ... event loop ...
    video.destroy_window(win);
    init.quit();
    return 0;
}
```

## Requirements

SDL3 and SDL3_ttf, installed as system libraries. On Arch:
`pacman -S sdl3 sdl3_ttf`. The manifest declares them with `system`, so the
linker is given `-lSDL3 -lSDL3_ttf` automatically, and transitively for anything
that depends on this.

## Quick start

```sh
git clone https://github.com/Caua726/caustic-sdl3
cd caustic-sdl3

caustic-mk run test            # every binding compiles, every example links
caustic-mk build spaceship && ./build/spaceship
```

## Using it in a project

```
target "mygame" {
    src "src/main.cst"
    out "build/mygame"
    depend "caustic-sdl3" in "https://github.com/Caua726/caustic-sdl3" tag "v0.1.0"
}
```

```cst
use "caustic-sdl3/video.cst" as video;
```

The `system "SDL3"` lines in this manifest are collected transitively, so your
target links SDL3 without declaring it again.

## Modules

| Module | Covers |
|---|---|
| `sdl3.cst` | the umbrella — re-exports the rest |
| `init.cst` | `SDL_Init`, `SDL_Quit`, subsystem flags |
| `video.cst` | windows, displays, fullscreen, window properties |
| `render.cst` | the 2D accelerated renderer: draw, copy, present |
| `surface.cst` | CPU surfaces, blitting, pixel formats |
| `windowsurface.cst` | the window's own CPU pixel buffer — a dumb framebuffer in a window, no renderer |
| `gpu.cst` | the SDL3 GPU API: devices, pipelines, buffers, passes |
| `events.cst` | the event queue and event-type constants |
| `keyboard.cst` | key state, scancodes, text input |
| `mouse.cst` | position, buttons, relative mode, cursors |
| `touch.cst` | touch devices and finger events |
| `gamepad.cst` | gamepads: open, axes, buttons, mappings |
| `haptic.cst` | rumble and force feedback |
| `audio.cst` | audio device streams, queue-based playback |
| `ttf.cst` | SDL3_ttf: fonts, text rendering to surfaces |
| `rect.cst` | rectangles and points, intersection and union |
| `timer.cst` | ticks, performance counter, delay |
| `clipboard.cst` | get and set clipboard text |
| `filesystem.cst` | base and preference paths |
| `messagebox.cst` | native message boxes |
| `platform.cst` | platform name and CPU queries |

## Examples

| Example | What it shows |
|---|---|
| `hello_window` | open a window, run an event loop, close cleanly |
| `draw_rects` | the 2D renderer: clear, fill rectangles, present |
| `spaceship` | a small game — input, timing, TTF text, sprites |

## Testing a binding library

There is one failure mode that matters here and it is not logic: the C API moves
and the declarations do not follow. `caustic-mk run test` compiles all 21 modules
individually and links all three examples against the installed SDL3, so both a
stale declaration and a missing symbol are caught.

This is not hypothetical — it is what the check found the first time it ran, in
a repository that had none: an SDL3 function rename in `keyboard.cst`, a
type error in `audio.cst`, and every example importing a standard-library path
that no longer existed.

## License

MIT — see [LICENSE](LICENSE).
