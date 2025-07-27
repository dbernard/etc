# Bashrc.d Modular Configuration

This directory contains modular bash configuration files that are loaded in numerical order by the main bashrc. This approach provides better maintainability, flexibility, and compatibility with organizational configurations.

## Module Loading Order

Modules are loaded in alphabetical/numerical order:

1. **00-core.sh** - Core environment setup and essential functions
2. **10-interactive.sh** - Interactive shell configuration  
3. **20-completion.sh** - Bash completion setup
4. **30-theme.sh** - Theme and prompt configuration
5. **99-user-local.sh** - User-specific local configuration

## Benefits

- **Modular**: Each component is self-contained and can be disabled by renaming
- **Non-intrusive**: Works alongside organizational bash configurations 
- **Maintainable**: Clear separation of concerns makes updates easier
- **Flexible**: Easy to enable/disable features by renaming files
- **Compatible**: Designed to coexist with `/etc/bashrc` and `/etc/profile.d/` configs

## Usage

### Disable a module
```bash
mv 20-completion.sh 20-completion.sh.disabled
```

### Add a custom module  
Create a new file with appropriate numbering, e.g., `50-my-custom.sh`

### Debug loading
Set `BASH_DEBUG_ETC=1` before sourcing to see module loading details

## Migration from Legacy

The original monolithic bashrc has been backed up as `bashrc.original`. The new modular approach maintains the same functionality while being more maintainable and organization-friendly.