# home-racker

![HomeRacker Assembly](./img/assembly_basics_4.png)

HomeRacker is a fully modular rack building system for virtually any "racking needs" (Server Rack, shoe rack, book shelf, you name it).

This repo though contains the respective `scad` files for all fully customizable models as well as the documentation for the entire project.

Everyting else (like the `HomeRacker - Core`) you can find on my [Makerworld Page](https://makerworld.com/en/@kellervater)). There I provide all all models (which I didn't transpile into `scad`) as f3d files.

# Development

>[!NOTE]
> Everything Jekyll-related has been tested using debian-based distros (in my case Ubuntu and WSL2 Ubuntu).

## Prerequisites
### System Dependencies
Install following system dependencies for debian-based OSs:
```bash
# required for asdf utilities in this repo
sudo apt install make
# required ruby dependencies
sudo apt install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
```
### asdf
You need to install [asdf](https://asdf-vm.com/guide/getting-started.html). You can do so by running the install script:
```bash
chmod +x install-asdf.sh && ./install-asdf.sh
```
This will add `asdf` and bash completion to your path.

### Plugins
Now you can install all plugins:
```bash
make asdf-install # due to some bug you might need to run it twice before it works
```
> [!NOTE]
> Since renovate is activated on this repository, this step might be reocurring due to regular udpates to plugin versions.

## Feedback?
Open an issue here rather than at Makerworld. I can track feature requests and bugs way easier here in Github.


## Licensing
* The source code in this repository is licensed under the `MIT License` (see [LICENSE](./LICENSE)).
* All 3D models and creative assets (in /models/) are licensed under the `CC BY-NC 4.0 License` (see [/models/LICENSE](./models/LICENSE)).
�