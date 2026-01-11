# HomeRacker Gridfinity

Gridfinity-compatible baseplates and bin bases implemented as reusable OpenSCAD modules for anyone to use.
This library is intended to make it easier to integrate Gridfinity interfaces to your models.

If you want to create a Gridfinity compatible shelf or drawer, use the `baseplate` module.
If you want to create a custom Gridfinity bin, use the `binbase` module.

## 📁 Structure

```
gridfinity/
├── base.scad           # Legacy entry point (deprecated - use lib/ modules)
├── lib/                # Gridfinity module definitions (implementation)
│   ├── baseplate.scad  # Baseplate module implementation (for surfaces)
│   └── binbase.scad    # Bin base module implementation (for containers)
├── parts/              # Single customizable instances of `lib` modules
│   ├── baseplate.scad  # Fully customizable baseplate (use OpenSCAD Customizer)
│   └── binbase.scad    # Fully customizable bin base
└── makerworld/         # Export-ready variants for MakerWorld
    ├── baseplate.scad  # Pre-configured baseplate variants
    └── binbase.scad    # Pre-configured bin base variants
```

## 🚀 Quick Start

### Using the Library

Include Gridfinity modules in your OpenSCAD projects:

```scad
include <gridfinity/lib/baseplate.scad>
include <gridfinity/lib/binbase.scad>

// Create a 3×2 baseplate
baseplate(grid_x=3, grid_y=2);

// Create a 1×2 bin base
binbase(grid_x=3, grid_y=2);

// This is a nice example as it places the binbase exactly onto the baseplate.
// Lets you examine tolerances :-D
```

### Customizing Parts

Open any file in `parts/` with OpenSCAD and use the **Customizer** panel to adjust parameters:

- **`baseplate.scad`**: Customize grid dimensions (x and y units)
- **`binbase.scad`**: Customize grid dimensions and preview with baseplate

### Exporting Variants

The `makerworld/` folder contains pre-configured variants for export as self contained to MakerWorld or other platforms.

## 🔧 Core Components

### 1. **Baseplate**
Mounting surface for Gridfinity bins and organizers.
- Standard Gridfinity 42mm grid spacing
- Precise dimensional compliance with grizzie17's specification
- Optimized for 0.4mm nozzle printing
- Compatible with all standard Gridfinity bins

### 2. **Bin Base**
Bottom mounting component for custom Gridfinity-compatible containers.
- Standard Gridfinity 42mm grid spacing
- Matches baseplate cutout geometry
- Stack securely on Gridfinity baseplates
- Build custom bins on top of this foundation

## 📐 Dimensional Standards

All dimensions follow [grizzie17's Gridfinity specification](https://www.printables.com/model/417152-gridfinity-specification) for maximum compatibility.

## 📝 License

- **Source Code**: MIT License

## 🔗 Resources

- [BOSL2 Library Documentation](https://github.com/BelfrySCAD/BOSL2/wiki)
- [Gridfinity Specification](https://www.printables.com/model/417152-gridfinity-specification)
