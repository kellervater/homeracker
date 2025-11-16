# HomeRacker Copilot Instructions

## Project Overview
HomeRacker is a fully modular 3D-printable rack-building system designed for versatile "racking needs" including server racks, shoe racks, bookshelves, and more. The project consists of:

- **HomeRacker Core**: Open-spec modular building system (MIT License)
- **3D Models**: Parametric and non-parametric models in OpenSCAD and Fusion 360 formats (CC BY SA 4.0)
- **Automation Scripts**: Fusion 360 export scripts for batch model generation
- **GitHub Pages Site**: Documentation and showcase website

## Core Technologies & Frameworks
- **3D Modeling**: OpenSCAD (parametric), Fusion 360 (.f3d files)
- **Languages**: SCAD (OpenSCAD), Python (Fusion 360 scripts)
- **Dependencies**: BOSL2 library for OpenSCAD
- **Web**: GitHub Pages with Jekyll (Architect theme)
- **Standards**: 10" and 19" rack specifications, custom HomeRacker dimensions

## Key Components Architecture
### Building Blocks
1. **Supports**: Structural elements (beams) with standardized connection points as holes for lock pins
2. **Connectors**: connection system for supports (front/back, left/right, up/down) - up to 6-way connections in a perpendicular 3D grid
3. **Lock Pins**: Securing mechanism for assembled connections. Lock connectors and supports together using 4mm square pins and rely on tension friction fit.

### Models Structure
- `/models/rackmount_ears/`: Fully customizable rackmount ears (OpenSCAD)
- `/models/gridfinity/`: Gridfinity-compatible base plates
- `/models/flexmount/`: Flexible mounting solutions
- `/models/shelf/`: Parametric shelf components
- `/models/wallmount/`: Wall mounting brackets

## Development Guidelines

### OpenSCAD Best Practices
- Use BOSL2 library for advanced geometric operations
- Set `$fn=100` for smooth curves in production models
- Implement parametric designs with customizer-friendly variables
- Group parameters logically with `/* [Section Name] */` comments
- Provide sensible defaults and value ranges for sliders
- Include sanity checks for critical parameters
- Use descriptive variable names following `CONSTANT_CASE` for constants

### File Organization
- Keep `.scad` files in appropriate `/models/` subdirectories
- Include example images showing customization options
- Maintain `README.md` files explaining each model's purpose

### Documentation Standards
- Use emoji headers for visual organization (🔧, ✨, 📐, etc.)
- Include clear assembly instructions with diagrams
- Provide printing tips and material recommendations
- Document all customizable parameters
- Include real-world use case examples

### Code Quality
- Comment complex geometric calculations
- Use meaningful module names
- Separate configuration from implementation
- Test parameter ranges for edge cases
- Validate dimensional accuracy against rack standards

## Project-Specific Context

### HomeRacker Core Dimensional Standards
- **Base Unit**: 15mm (core measurement for all HomeRacker components)
- **Lock Pin Side**: 4mm (square profile for pins and matching holes)
- **Wall Thickness**: 2mm (standard connector wall thickness)
- **Standard Tolerance**: 0.2mm (added to connector interiors for print variances)
- **Support Dimensions**: 15mm x 15mm base, height = multiples of 15mm
- **Connector Centers**: Always 1 base unit (15mm) in height
- **Lock Pin Edge Distance**: 5.5mm from support edges
- **Standard Chamfer**: 1mm for printability

### Licensing Requirements
- Source code: MIT License (commercial use allowed)
- 3D models & assets: CC BY SA 4.0 (attribution required, share-alike)
- Always include proper license headers in new files
- Credit original work when modifying existing models

### Brand Guidelines
- Use "HomeRacker" (not "Home Racker" or "home-racker")
- Include HomeRacker logo overlay on compatible model thumbnails
- Maintain consistent visual style across documentation
- Reference Makerworld links for published models

## Common Tasks & Patterns

### Creating New Models
1. Start with parametric design in OpenSCAD
2. Prefer using BOSL2 library for all complex geometry (always lookup online docs https://github.com/BelfrySCAD/BOSL2/wiki)
3. Include customizer parameters with proper grouping
4. Test with common device dimensions
5. Export STL files for immediate use
6. Document parameters and use cases
7. Add example images showing variations

### Fusion 360 Scripts
- Place scripts in `/scripts/` with proper manifest files
- Include usage instructions in README.md
- Test export functionality across parameter ranges
- Validate output file naming conventions

### Documentation Updates
- Update main README.md for new features
- Include visual examples with actual photos
- Link to Makerworld models where applicable
- Maintain table of contents structure

## Self-Improvement Instructions

### When Encountering Wrong Turns
If you find yourself making incorrect assumptions or heading down the wrong path during development assistance:

1. **Pause and Reassess**: Stop the current approach and explicitly state what went wrong
2. **Gather Context**: Re-read project documentation, examine existing code patterns, and understand the specific use case better
3. **Ask Clarifying Questions**: Request specific details about requirements, constraints, or expected outcomes
4. **Document the Learning**: Add insights to these instructions for future reference

### Instruction Enhancement Protocol
When updating these instructions based on new learnings:

1. **Preserve Core Structure**: Maintain the organized sections and GitHub best practices format
2. **Add Specific Examples**: Include concrete code snippets or configuration examples that caused confusion
3. **Update Technology Stack**: Keep dependencies, tools, and version requirements current
4. **Expand Edge Cases**: Document unusual scenarios or parameter combinations that need special handling
5. **Validate Changes**: Ensure new instructions don't conflict with existing project patterns

### Learning from Mistakes
Common areas for improvement:
- **Dimensional Accuracy**: Double-check rack standards and measurement conversions
- **Parameter Validation**: Ensure SCAD parameters have proper bounds and error checking
- **File Naming**: Follow established conventions for exports and derivatives
- **License Compliance**: Verify all new content uses appropriate licensing
- **Cross-Platform Compatibility**: Consider Windows/Linux/macOS differences in file paths and tools

### Feedback Integration
When receiving feedback about incorrect suggestions:
1. Acknowledge the specific error made
2. Explain the corrected approach
3. Update relevant sections of these instructions
4. Test the corrected approach before suggesting it again

## Troubleshooting Common Issues

### OpenSCAD Problems
- **Rendering Issues**: Check for overlapping geometry, invalid meshes, or extreme parameter values
- **BOSL2 Errors**: Verify library installation and include statements
- **Performance**: Reduce `$fn` for development, increase for final exports

### Export Script Issues
- **Fusion 360 API**: Check for API version compatibility and parameter access methods
- **File Paths**: Use cross-platform path handling in Python scripts
- **Batch Operations**: Implement proper error handling for automated exports

### Documentation Sync
- **Broken Links**: Validate all external references to Makerworld and GitHub
- **Image References**: Ensure all images exist and use correct relative paths
- **Version Mismatches**: Keep model versions synchronized between repository and published versions

Remember: HomeRacker is about modularity, openness, and practical maker solutions. Always consider how suggestions support these core principles while maintaining professional engineering standards.
