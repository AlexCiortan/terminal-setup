# Contributing to Terminal Setup

Thank you for your interest in contributing! This project welcomes contributions from everyone.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected vs actual behavior
- Your macOS version and hardware (e.g., M1, M2, M3)
- Relevant logs or screenshots

### Suggesting Enhancements

Feature requests are welcome! Please:
- Check if the feature is already suggested
- Explain the use case clearly
- Describe how it would work

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Test your changes thoroughly
4. Commit with clear messages (`git commit -m 'Add amazing feature'`)
5. Push to your branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

### Code Style

- Use clear, descriptive variable names
- Add comments for complex logic
- Follow existing code formatting
- Test on a fresh macOS install if possible

### Testing Checklist

Before submitting a PR, ensure:
- [ ] Installation works on a clean system
- [ ] All config files are valid
- [ ] Documentation is updated
- [ ] No hardcoded personal information

## Development Setup

```bash
# Clone your fork
git clone https://github.com/AlexCiortan/terminal-setup.git
cd terminal-setup

# Test the installer
chmod +x install.sh
./install.sh
```

## Project Structure

- `install.sh` - Main installer (keep it user-friendly!)
- `configs/` - Configuration templates (test before committing)
- `docs/` - Documentation (keep it clear and concise)

## Questions?

Feel free to open an issue for any questions!

---

Thank you for contributing! 🎉
