# :building_construction: HomeRacker - The universal modular rack building system
[![forthebadge](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxNTcuOTUzMTM2NDQ0MDkxOCIgaGVpZ2h0PSIzNSIgdmlld0JveD0iMCAwIDE1Ny45NTMxMzY0NDQwOTE4IDM1Ij48cmVjdCB3aWR0aD0iMTA2LjYyNTAwNzYyOTM5NDUzIiBoZWlnaHQ9IjM1IiBmaWxsPSIjZjZhYTRhIi8+PHJlY3QgeD0iMTA2LjYyNTAwNzYyOTM5NDUzIiB3aWR0aD0iNTEuMzI4MTI4ODE0Njk3MjY2IiBoZWlnaHQ9IjM1IiBmaWxsPSIjZmY4ZjAwIi8+PHRleHQgeD0iNTMuMzEyNTAzODE0Njk3MjY2IiB5PSIyMS41IiBmb250LXNpemU9IjEyIiBmb250LWZhbWlseT0iJ1JvYm90bycsIHNhbnMtc2VyaWYiIGZpbGw9IiNGRkZGRkYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGxldHRlci1zcGFjaW5nPSIyIj5ET1dOTE9BRDwvdGV4dD48dGV4dCB4PSIxMzIuMjg5MDcyMDM2NzQzMTYiIHk9IjIxLjUiIGZvbnQtc2l6ZT0iMTIiIGZvbnQtZmFtaWx5PSInTW9udHNlcnJhdCcsIHNhbnMtc2VyaWYiIGZpbGw9IiNGRkZGRkYiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZvbnQtd2VpZ2h0PSI5MDAiIGxldHRlci1zcGFjaW5nPSIyIj5GM0Q8L3RleHQ+PC9zdmc+)](https://makerworld.com/en/@kellervater)
![HomeRacker Assembly](./img/assembly_basics_4.png)

HomeRacker is a fully modular rack building system for virtually any "racking needs" (Server Rack, shoe rack, book shelf, you name it).

This repo contains the respective `scad` files for all fully customizable models as well as the documentation for the entire project which seeds the page https://homeracker.org.

You can find all parametric and non-parametric models as well as the `f3d` files (like the `HomeRacker - Core`) on [Makerworld](https://makerworld.com/en/@kellervater)).

# :woman_technologist: Development
>[!NOTE]
> Everything Jekyll-related has been tested using debian-based distros (in my case Ubuntu and WSL2 Ubuntu).

## :toolbox: Prerequisites
### :pushpin: System Dependencies
Install following system dependencies for debian-based OSs:
```bash
# required for asdf utilities in this repo
sudo apt install make
# required ruby dependencies
sudo apt install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
```
### :robot: asdf
You need to install [asdf](https://asdf-vm.com/guide/getting-started.html). You can do so by running the install script:
```bash
chmod +x install-asdf.sh && ./install-asdf.sh
```
This will add `asdf` and bash completion to your path.

### :electric_plug: Plugins
Now you can install all plugins:
```bash
make asdf-install # due to some bug you might need to run it twice before it works
```
> [!NOTE]
> Since renovate is activated on this repository, this step might be reocurring due to regular udpates to plugin versions.

### Install Gems
Now you finally can install Jekyll:
```shell
# Install Jekyll globally
gem install jekyll bundler
# Install jekyll for the project
bundle
```

## :seedling: Bootstrapping
I basically followed the Step-by-Step Guide: https://jekyllrb.com/docs/step-by-step/01-setup/

All necessary Jekyll commands have been already prefixed appropriately. Just use `make` with the respective jekyll command and you should be good to go.

# :speech_balloon: Feedback?
Open an issue here rather than at Makerworld. I can track feature requests and bugs way easier here in Github.

# :scroll: Licensing
* The source code in this repository is licensed under the `MIT License` (see [LICENSE](./LICENSE)).
* All 3D models and creative assets (in /models/) are licensed under the `CC BY-NC 4.0 License` (see [/models/LICENSE](./models/LICENSE)).

# :memo: Todos
* [ ] freeze Gemfile dependencies and make renovate work on it
