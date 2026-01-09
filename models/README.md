# Models
This folder contains all `scad` 3d models which come with the HomeRacker project.

## Contents

### Core
The fundamental HomeRacker building system with modular components:
- **Supports**: Vertical and horizontal structural elements
- **Connectors**: Join supports in a variety of dimensions
- **Lock Pins**: Secure connections without tools

See [core/README.md](core/README.md) for details.

### Gridfinity
Parametric Gridfinity-compatible baseplates for modular storage:
- **Baseplates**: Configurable grid dimensions (42mm units)
- Optimized for 0.4mm nozzle printing
- Uses adaptive circle resolution for performance

### Rackmount Ears
Fully customizable rackmount ears for standard rack mounting.

Examples:
![Only 1 Bore Row](./rackmount_ears/rackmount_ear_1_bore_row_example.png)
![2 Height Units](./rackmount_ears/rackmount_ear_2hu_example.png)

---

**MakerWorld exports**: Files in `<model_type>/parts/` are automatically exported on commit. See [cmd/export/README.md](../cmd/export/README.md) for details.
