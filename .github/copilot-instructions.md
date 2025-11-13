# HomeRacker Copilot Instructions

## Project Overview
HomeRacker is a modular 3D-printable rack-building system. Core components use parametric OpenSCAD models (BOSL2 library). Licensed: MIT (code), CC BY SA 4.0 (models).

## Tools & Structure
- **Languages**: OpenSCAD (.scad), Python, Bash
- **Key Dirs**: `/models/` (SCAD files), `/bin/` (tools), `/scripts/` (Fusion 360 automation)
- **HomeRacker Standards**: 15mm base unit, 4mm lock pins, 2mm walls, 0.2mm tolerance. See `README.md` for details.

## Core Principles
- **DRY, KISS, YAGNI**: Keep it simple, don't over-engineer
- **Docs**: Concise and essential only (Use-cases, parameters, minimal examples)
- **Testing**: Always test changes; use existing test files or create automated tests if feasible

## **MANDATORY** Workflow
1. **Check repo patterns** first for consistency
2. **Consult online docs** (especially BOSL2: https://github.com/BelfrySCAD/BOSL2/wiki)
3. **Ask before proceeding** if requirements conflict with best practices
4. **Provide outline** before implementation for confirmation
5. **On errors**: Step back, check docs, ask user if stuck—don't iterate blindly

## OpenSCAD Guidelines
- Use BOSL2 for complex geometry
- Set `$fn=100` for production
- Group parameters with `/* [Section] */` comments
- Include sanity checks for critical params
- Test parameter ranges for edge cases
