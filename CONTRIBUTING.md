# Contributing to HomeRacker

Thanks for your interest in contributing! Even getting this far is already worth a ton 🏋

## 🚀 Quick Start

```bash
# Clone and setup
git clone https://github.com/kellervater/homeracker.git
cd homeracker

# Install OpenSCAD (Windows/Git Bash)
./tools/install-openscad.sh
./tools/install-dependencies.sh

# Verify installation
./tools/test-openscad.sh
```

## 📐 HomeRacker Standards

- **Base unit**: 15mm
- **Lock pins**: 4mm square
- **Walls**: 2mm thickness
- **Tolerance**: 0.2mm
- **Quality**: `$fn=100` for production

## 🛠️ Development Guidelines

### Code Standards
- **DRY, KISS, YAGNI** - Keep it simple
- Use [BOSL2](https://github.com/BelfrySCAD/BOSL2/wiki) for complex geometry
- Group parameters with `/* [Section] */` comments
- Add sanity checks: `assert(height % 15 == 0, "Must be multiple of 15mm")`

### Testing
- Render in OpenSCAD without errors
- Test edge cases (min/max parameter values)
- Export to STL and verify mesh integrity

## 📝 Commit Conventions

Use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
feat: add gridfinity adapter
fix: correct wallmount tolerance
docs: update installation guide
chore: bump OpenSCAD version
test: added Testsuite for new devil fruit model
```

**Types**: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `perf`  
**Breaking changes**: Add `!` (e.g., `feat!: change base unit to 20mm`)

## 🔄 Pull Request Workflow

1. Create branch or fork: `git checkout -b feature/my-feature`
2. Make changes following standards above
3. Test thoroughly
4. Commit: `git commit -m "feat: add cool feature"`
5. Push: `git push origin feature/my-feature`
6. Create PR with description and screenshots

## 📂 Project Structure

```
models/              # OpenSCAD models
  ├── wallmount/    # Wall mounting
  ├── flexmount/    # Flexible mounts
  ├── gridfinity/   # Gridfinity integration
  └── core/         # Core components
tools/              # Installation & test scripts
```

## 💬 Getting Help

- [Open an issue](https://github.com/kellervater/homeracker/issues) for bugs/features
- [Start a discussion](https://github.com/kellervater/homeracker/discussions) for questions

## 📜 License

Contributions are licensed under MIT (code) and CC BY-SA 4.0 (models).

---

**Platform**: Windows (Git Bash) | macOS/Linux support: [#40](https://github.com/kellervater/homeracker/issues/40)
