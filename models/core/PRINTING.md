# 3D Printing Notes for HomeRacker Core

This document provides specific guidance for 3D printing the HomeRacker Core modules, with emphasis on the `extended` grip type of the lock pin.

---

## Lock Pins: `extended` Grip Type

The `extended` grip type adds an enlarged outer grip arm to improve handling. While functional, it introduces trade-offs for 3D printing that users should be aware of.

### 1. Supports Required

- In the default orientation, the extended grip arm protrudes **both above and below** the lock pin body.
- This creates **unsupported overhangs**, which slicer software will typically require supports to print successfully.
- Using supports will increase:
    - Material consumption
    - Print time
    - Post-processing effort
    - Surface imperfections at support contact points

The `standard` and `no-grip` variants are designed to print without supports in typical settings.

---

### 2. Alternative Orientation

Printing the lock pin **vertically** (upright) can avoid the need for supports. However:

- Layer lines are reoriented relative to the primary load paths of the part.
- This may reduce mechanical stability under long-term stress.
- Higher risk of:
    - Layer separation
    - Fracture at stress points
    - Increased creep over time (especially with common thermoplastics)

Vertical printing is generally **not recommended** for functional, load-bearing lock pins.

---

### 3. Practical Recommendations

- For **support-free printing and optimal mechanical strength**, prefer:
    - `standard` grip
    - `no-grip`
- Use `extended` grip only when additional grip surface is necessary and support usage is acceptable.

Proper slicer configuration, material choice, and post-processing are essential when printing the `extended` variant.

---

## General 3D Printing Guidelines

- **Layer Height**: 0.2–0.3mm recommended for precision
- **Material**: PLA, PETG, or ABS depending on desired strength
- **Infill**: 20–40% for structural parts; 100% for tension-critical pins
- **Supports**: Enable only where necessary to minimize material waste
- **Orientation**: Default orientation is generally preferred unless noted otherwise
