# HomeRacker Core

The core building system for HomeRacker - the fully modular 3D-printable rack-building platform.

## 📁 Structure

```
core/
├── main.scad          # Main library entry point - include this to use base HomeRacker modules from `lib`
├── lib/               # Core module definitions (implementation)
│   ├── connector.scad  # Connector module implementation
│   ├── support.scad    # Support beam module implementation
│   ├── lockpin.scad    # Lock pin module implementation
│   └── constants.scad  # Shared constants and dimensions
├── parts/              # Single customizable instances of `lib` modules
│   ├── connector.scad  # Fully customizable connector (use OpenSCAD Customizer)
│   ├── support.scad    # Fully customizable support beam
│   └── lockpin.scad    # Fully customizable lock pin
└── presets/            # Pre-configured variant collections
    ├── connectors.scad # All useful connector variants for export
    ├── supports.scad   # All useful support variants for export
    └── lockpins.scad   # All useful lock pin variants for export
```

## 🚀 Quick Start

### Using the Library

Include the core library in your OpenSCAD projects:

```scad
use <core/main.scad>

// Create a 3-directional connector
connector(dimensions=3, directions=3);

// Create a support beam (3 units long)
support(units=3);

// Create a lock pin with standard grip
lockpin(grip_type="standard");
```

### Customizing Parts

Open any file in `parts/` with OpenSCAD and use the **Customizer** panel to adjust parameters:

- **`connector.scad`**: Customize dimensions, directions, pull-through axes, feet, and orientation
- **`support.scad`**: Customize length and hole configurations
- **`lockpin.scad`**: Customize grip type (standard, extended or no-grip)

### Exporting Variants

The `presets/` folder contains modules for batch-exporting all logical variants:

- **`connectors.scad`**: Organized collections (standard, feet, pull-through, etc.)
- **`supports.scad`**: Various support lengths with different hole configurations
- **`lockpins.scad`**: Standard grip, extended and no-grip variants

## 🔧 Core Components

### 1. **Supports** (Beams)
Structural elements with standardized connection points.
- 15mm × 15mm cross-section
- Configurable length (multiples of 15mm)
- Optional X-axis holes for cable management

### 2. **Connectors**
Junction pieces that join supports in multiple directions.
- 1D, 2D, or 3D variants (up to 6 directions)
- Optional feet for vertical stability
- Optional pull-through axes for complex builds
- Lock pin holes (4mm square pins)

### 3. **Lock Pins**
4mm square pins that secure connectors to supports via tension fit.
- Standard grip: Two grip arms for easy insertion/removal
- Extended grip: Two asymmetric grip arms with a dominant outer arm.
- No-grip variant: Smooth design for minimal profile
- Bidirectional tension hole for secure fit

## 📐 Dimensional Standards

- **Base Unit**: 15mm
- **Lock Pin**: 4mm square
- **Wall Thickness**: 2mm
- **Tolerance**: 0.2mm (built into connectors)
- **Standard Chamfer**: 1mm
- **Lock Pin Chamfer**: 0.8mm

## 📝 License

- **Source Code**: MIT License
- **3D Models**: CC BY-SA 4.0

## 🔗 Resources

- [Main Repository](https://github.com/kellervater/homeracker)
- [BOSL2 Library Documentation](https://github.com/BelfrySCAD/BOSL2/wiki)
