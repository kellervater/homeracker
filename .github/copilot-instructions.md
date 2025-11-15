# HomeRacker Copilot Instructions

## Project Overview
HomeRacker is a modular 3D-printable rack-building system. Core components use parametric OpenSCAD models (BOSL2 library). Licensed: MIT (code), CC BY SA 4.0 (models).

## Tools & Structure
- **Languages**: OpenSCAD (.scad), Python, Bash
- **Key Dirs**: `/models/` (SCAD files), `/bin/` (tools), `/scripts/` (Fusion 360 automation)
- **HomeRacker Standards**: 15mm base unit, 4mm lock pins, 2mm walls, 0.2mm tolerance. See `README.md` for details.

## Core Principles
- **DRY, KISS, YAGNI**: Keep it simple, don't over-engineer
- **Be Brief**: All outputs (code, docs, issues, PRs) should be minimal and to-the-point
  - Code: No unnecessary comments, clear variable names speak for themselves
  - Docs: Essential info only - what/why/how in <100 lines when possible
  - GitHub issues/PRs: Clear problem/solution, skip verbose explanations
- **Testing**: Always test changes; use existing test files or create automated tests if feasible
- **Commits**: Use [Conventional Commits](https://www.conventionalcommits.org/) format
  - Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`
  - Format: `type(scope): description` or `type: description`
  - Breaking changes: Add `!` (e.g., `feat!: change base unit`)

## **MANDATORY** Workflow
1. **Check repo patterns** first for consistency
2. **Consult online docs** (especially BOSL2: https://github.com/BelfrySCAD/BOSL2/wiki)
3. **Ask before proceeding** if requirements conflict with best practices
4. **Provide outline** before implementation for confirmation
5. **Test all changes** (see `TESTING.md` for details)
6. **On errors**: Step back, check docs, ask user if stuck—don't iterate blindly

## OpenSCAD Guidelines
- Use BOSL2 for complex geometry
- Set `$fn=100` for production
- Group parameters with `/* [Section] */` comments
- Include sanity checks for critical params
- Test parameter ranges for edge cases
