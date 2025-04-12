[What's it for?](#use-cases) | [How does it work?](#how-it-works) | [Free & OpenSource](#open-standard)

[![forthebadge](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNTcuOTUzMTM2NDQ0MDkxOCIgaGVpZ2h0PSIzNSIgdmlld0JveD0iMCAwIDE1Ny45NTMxMzY0NDQwOTE4IDM1Ij48cmVjdCB3aWR0aD0iMTA2LjYyNTAwNzYyOTM5NDUzIiBoZWlnaHQ9IjM1IiBmaWxsPSIjZjZhYTRhIi8+PHJlY3QgeD0iMTA2LjYyNTAwNzYyOTM5NDUzIiB3aWR0aD0iNTEuMzI4MTI4ODE0Njk3MjY2IiBoZWlnaHQ9IjM1IiBmaWxsPSIjZmY4ZjAwIi8+PHRleHQgeD0iNTMuMzEyNTAzODE0Njk3MjY2IiB5PSIyMS41IiBmb250LXNpemU9IjEyIiBmb250LWZhbWlseT0iJ1JvYm90bycsIHNhbnMtc2VyaWYiIGZpbGw9IiNGRkZGRkYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGxldHRlci1zcGFjaW5nPSIyIj5ET1dOTE9BRDwvdGV4dD48dGV4dCB4PSIxMzIuMjg5MDcyMDM2NzQzMTYiIHk9IjIxLjUiIGZvbnQtc2l6ZT0iMTIiIGZvbnQtZmFtaWx5PSInTW9udHNlcnJhdCcsIHNhbnMtc2VyaWYiIGZpbGw9IiNGRkZGRkYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZvbnQtd2VpZ2h0PSI5MDAiIGxldHRlci1zcGFjaW5nPSIyIj5GM0Q8L3RleHQ+PC9zdmc+)](https://makerworld.com/en/@kellervater)
![HomeRacker Assembly](./img/assembly_basics_4.png)

HomeRacker is a fully modular 3D-printable rack building system for virtually any "racking needs" (Server Rack, shoe rack, book shelf, you name it).

This repo contains the respective `scad` files for all fully customizable models as well as the documentation for the entire project which seeds the page https://homeracker.org.

You can find all parametric and non-parametric models as well as the `f3d` files (like the `HomeRacker - Core`) on [Makerworld](https://makerworld.com/en/@kellervater)).

> [!NOTE]
> The basic HomeRacker system is also referred to as `HomeRacker - Core`. Free for everyone to use.

# Table of Contents
- [Use Cases](#use-cases)
- [Open Standard](#open-standard)
  - [Basic building blocks](#basic-building-blocks)
    - [Supports](#supports)
    - [Connectors](#connectors)
    - [Spring Pins](#spring-pins)
- [Why the name?](#why-the-name)
- [📜 Licensing](#-licensing)
- [Todos](#todos)

# Use Cases
Initially I created HomeRacker, because I wasn't happy with any of the creations available on the Internet.
Some where too specific by only allowing certain devices which the original creator owned. Other's "only" allowed a 10" standard but no deviations and still the need for adapters to fit the 10" standard.
As I am currently (April 2025) starting my homelab journey I wanted a solution which is so modular that it can grow with the demands of an ongoing homelab journey without having to buy the next bigger rack or to change concepts after a while because the originally intended concept doesn't work out in the long run.

![xkcd: The General Problem](https://imgs.xkcd.com/comics/the_general_problem.png)

As it is my nature to overengineer everything, I came up with a more generic solution to serve ANY "racking needs". Be it to build a small rack for a few Raspberry Pi's, a 10" standard rack for HomeLabs or even a 19" standard rack (still working on that though). You can even create book shelfs, shoe racks or combine all of the above in an abomination of a rack.

To give you an idea of how this may look like (10" rack, half constructed PI mini-rack, book shelf):
![Real Life Example](./img/real_life_example.jpg)

Aside from the basic [building blocks](#basic-building-blocks) above's racks also contain following parts:
* 10" Rack
  * HomeRacker - 10" Rackmount Kit (Todo: link to Makerworld Model) for standard height units
  * Raspi 5 Mount Kit
    * Vertical Mount Adapter for HomeRacker
    * Front-Panel for 10" racks
  * Rackmount Ears for the Switch. These are fully customizable rackmount ears which I created as [openSCAD file](./models/rackmount_ears/rackmount_ears.scad). You can customize it directly [here](https://makerworld.com/en/models/1259227-fully-customizable-rackmount-ears#profileId-1283271).
  * HomeRacker Airflow Kit (Todo: link to Makerworld Model) which consists of
    * Front/Back panels
    * Side panels
    * Bottom/Top panels with air intake/exhaust grid and bores for standard fans (80/92/120mm)
* Shelf (You can build any shelf) 

# Features
The `HomeRacker - Core` features:
* Full modularity - Due to the support-connector system you can scale out in any direction. Only limit is the material strength
* 3D-printable - The entire core system is printable and no additional tools are required to assemble it. No need to include batteries here
* No supports - Not a single part of the core system needs printed supports.
* OpenSource - Feel free to build your own adapters and/or use it in all your personal or commercial projects (see [Open Standard](#open-standard) and [Licensing](#-licensing) for details).

## How it works
### Assembly Basics

![Assembly Basics 4 White](./img/assembly_basics_4_white.png)

The assembly process for the `HomeRacker - Core` system is straightforward and requires no additional tools. Follow these steps:

1. **Prepare the Components**: Download the HomeRacker-Core (Todo: insert link) and print all parts required to assemble your specific rack. Ensure the parts are clean and free of debris.
2. **Connect Supports and Connectors**: Attach the connectors to the supports as per your desired configuration. The modular design allows for flexibility in size and shape.
3. **Secure with Spring Pins**: Use the spring pins to lock the connectors and supports in place. This ensures stability and prevents accidental disassembly. Due to their quadratic profile they can be inserted horizontally or vertically. Make sure they are fully inserted. Normally you hear a click when that's the case. You can use a bit of force but not too much.
4. **Add Additional Features**: (not part of the core system) Depending on your use case, attach shelves, panels, or other accessories to complete your rack.

> [!NOTE]
> **PRO-Tip**: If you need to disassemble your rack for whatever reason and the spring pin fits so tight, that you would rip out your fingernail pulling on it, just press a pin from the other side onto the pin in question. This should help pulling it out.

## Tech Specs
> [!NOTE]
> To inspect the actual values I highly recommend checking out the somewhat okISH original fusion (`f3d`) files which are ALWAYS part of my Makerworld uploads. I always parameterize my designs so they can scale without problem.

The entire system revolves around 4 simple numbers:
1. 15mm - This is the so called `base_unit` or `base_length` in all my models. It ressembles the side length of each side of a support. x and y are fixed to 15mm and z is always a multiple of this depending on the desired unit count of a support
2. 4mm - Is the side length of each end of a spring pin and it's corresponding holes in the supports.
3. 2mm - Is the strength of the connector walls.

> These numbers (except for the tolerance) where purely arbitrary because I assumed they made sense. There wasn't any static calculation behind it.

### Supports


### Connectors
![3D Shot of All Connectors](./img/3d_shot_all_connectors.png)

### Spring Pins



## Open Standard
I created the `HomeRacker - Core` system to be an open standard which every maker can build upon with (almost) no strings attached (see [Licensing](#-licensing) for details).



Therefore I highly encourage all of you to build your own creations building upon the HomeRacker system.
If you let me know about your projects, I will feature them here on this site and cross-link them on MakerWorld (provided they get my "totally" objective stamp of approval). Just [create an issue](https://github.com/kellervater/homeracker/issues/new) here if you want to be featured!

## Contributing
As described in the 

# Why the name?
Following about four hours of research, I discovered that all my initial naming ideas (such as UniRack, OpenRack, etc.) were already in use by other creators or companies.

So, HomeRacker is a bit of a tongue-in-cheek creation. It combines the practical ability to build racks for homelabs with a more humorous, if slightly concerning, potential to literally become a "homewrecker" when the joy of building racks consumes too much time that could be spent with loved ones.

# 📜 Licensing

> [!NOTE]
> tl;dr - Use it for ANY purpose (even commercial), but don't forget to give credit and to share it the same way!

* The source code in this repository is licensed under the `MIT License` (see [LICENSE](./LICENSE)).
* All 3D models and creative assets (in /models/) are licensed under the `CC BY 4.0 License` (see [/models/LICENSE](./models/LICENSE)).

These licenses apply ONLY to the `HomeRacker - Core` system and the customizable rackmount ears. So, basically all content of this repository.

> [!IMPORTANT]
> All other models and derivates of HomeRacker I created may be released under less permissive licenses. But this will be disclosed at the respective models on MakerWorld.

# Tests
Of course I tested stuff... It took me 4 months from the idea to the first release here.
Look at the prototypes:

## Disclaimer
> [!WARNING]
> This project is provided "as is" without any warranty of any kind. Use it at your own risk. The creators are not responsible for any damage, injury, or loss caused by the use of this project or its components. Always ensure proper safety precautions when assembling or using the HomeRacker system.

Aside from the scary warning above, I need to mention, that due to the high modularity of this system combined with limited time and resources I was of course not able to test every combination of filaments, printers, print-settings, room conditions (temperature, humidity) or to do extensive load-bearing tests.

What I want to say:
I feel like the model turned out to be really nice and versatile. That's why I shared it in the first place.
But since I do not have control over the manufacturing conditions of any consumer of this model, I cannot give any guarantees on how your specific print will turn out in the end. There are just too much variables which not even the best model design can compensate for. (Writing this feels a bit like an upfront apology... seems like I'm a people pleaser)

## How I tested
My setup is as follows:
* a room temperature between 17 and 25°C
* Humidity levels between 29% and 36% (depends on when I'm doing my laundry)
* A BambuLab X1C printer
* Exclusively BambuLab filament (haven't tried others yet)
  * PLA Matte (I love the charcoal color. Looks so silky)
  * PLA Basic
  * ABS
* mostly I used the Textured PEI plate. It just works (provided you regularly clean it using Isopropyl alcohol). For the rest of the time I tried out the Cold Plate Super Track (it's nice but very hard to get your prints of the plates when it cools)

All above's filaments can be be combined in any possible way (just make sure you do flow calibration before using new filaments. First ABS print turned out horribly just because I forgot to click the calibration checkbox).
E.g.: you could print a connector in ABS, a support in PLA Matte and a spring pin in PLA and they will just fit when being assembled.

> 🛠️ **Btw:** I am not affiliated with Bambu in any way besides uploading my models to MakerWorld and occasionally making use of their Exclusive Model program. But they don't pay me for naming their products anywhere else (I wish 😉).

# Todos
* [ ] Rename Building blocks in f3d (did bad translations from german to english there)
* [ ] Release models on MakerLab
  * [ ] HomeRacker - Core (under above's license, non-exclusive)
  * [ ] HomeRacker - 10" Rackmount Kit (exclusive)
  * [ ] HomeRacker - Pi5 Mount Kit (exclusive)
  * [x] Customizable Rackmount Ears
  * [ ] HomeRacker - Airflow Kit (exclusive)
  * [ ] HomeRacker - Shelf
* [ ] Can we even call it a standard yet?