#!/bin/bash
# Zathura PDF Viewer Complete Setup Script for Arch Linux

echo "Installing Zathura and dependencies..."

# Install core packages
sudo pacman -S --needed \
    zathura \
    zathura-pdf-mupdf \
    xdg-utils \
    desktop-file-utils

# Optional dependencies for additional features
sudo pacman -S --needed \
    zathura-djvu \
    zathura-ps \
    zathura-cb \
    synctex

echo "Creating Zathura config directory..."
mkdir -p ~/.config/zathura

echo "Creating Zathura configuration file..."
cat > ~/.config/zathura/zathurarc << 'EOF'
# Zathura Configuration File

# UI Settings
set selection-clipboard clipboard
set window-title-basename true
set statusbar-home-tilde true
set page-padding 3
set adjust-open "width"
set smooth-scroll true
set scroll-step 100

# Zoom settings
set zoom-min 10
set zoom-max 1000
set zoom-step 5

# Search settings
set incremental-search true
set search-hadjust true

# Appearance - Dark theme
set notification-error-bg "#ff5555"
set notification-error-fg "#f8f8f2"
set notification-warning-bg "#ffb86c"
set notification-warning-fg "#44475a"
set notification-bg "#282a36"
set notification-fg "#f8f8f2"

set completion-bg "#282a36"
set completion-fg "#6272a4"
set completion-group-bg "#282a36"
set completion-group-fg "#bd93f9"
set completion-highlight-bg "#44475a"
set completion-highlight-fg "#f8f8f2"

set index-bg "#282a36"
set index-fg "#f8f8f2"
set index-active-bg "#44475a"
set index-active-fg "#f8f8f2"

set inputbar-bg "#282a36"
set inputbar-fg "#f8f8f2"
set statusbar-bg "#282a36"
set statusbar-fg "#f8f8f2"

set highlight-color "#ffb86c"
set highlight-active-color "#ff79c6"

set default-bg "#282a36"
set default-fg "#f8f8f2"
set render-loading true
set render-loading-fg "#282a36"
set render-loading-bg "#f8f8f2"

# Recolor mode (inverted colors for reading)
set recolor-lightcolor "#282a36"
set recolor-darkcolor "#f8f8f2"
set recolor false
set recolor-keephue true

# Key bindings
map <C-i> recolor
map r rotate
map R reload
map p print
map i set recolor
map u scroll half-up
map d scroll half-down
map D toggle_page_mode
map K zoom in
map J zoom out
map <C-f> toggle_fullscreen
map <C-n> navigate next
map <C-p> navigate previous

# Page layout
set pages-per-row 1
set first-page-column 1:1

# Performance
set scroll-page-aware true
set vertical-center true

# Database for history
set database sqlite
EOF

echo "Setting Zathura as default PDF viewer..."

# Create/update mimeapps.list
mkdir -p ~/.config
cat > ~/.config/mimeapps.list << 'EOF'
[Default Applications]
application/pdf=org.pwmt.zathura.desktop
application/x-pdf=org.pwmt.zathura.desktop
application/x-bzpdf=org.pwmt.zathura.desktop
application/x-gzpdf=org.pwmt.zathura.desktop
application/postscript=org.pwmt.zathura.desktop
image/vnd.djvu=org.pwmt.zathura.desktop
image/x-djvu=org.pwmt.zathura.desktop
application/x-cbr=org.pwmt.zathura.desktop
application/x-cbz=org.pwmt.zathura.desktop
application/x-cb7=org.pwmt.zathura.desktop
application/x-cbt=org.pwmt.zathura.desktop

[Added Associations]
application/pdf=org.pwmt.zathura.desktop
EOF

# Update XDG defaults
xdg-mime default org.pwmt.zathura.desktop application/pdf
xdg-mime default org.pwmt.zathura.desktop application/x-pdf

# Update desktop database
update-desktop-database ~/.local/share/applications 2>/dev/null || true

echo ""
echo "✓ Installation complete!"
echo ""
echo "Zathura is now configured as your default PDF viewer."
echo ""
echo "Key bindings:"
echo "  h/j/k/l      - Navigate (vim-style)"
echo "  u/d          - Half page up/down"
echo "  Ctrl+i       - Toggle recolor mode"
echo "  r            - Rotate page"
echo "  R            - Reload document"
echo "  K/J          - Zoom in/out"
echo "  Ctrl+f       - Toggle fullscreen"
echo "  q            - Quit"
echo "  f            - Follow links"
echo "  /            - Search"
echo ""
echo "Config location: ~/.config/zathura/zathurarc"
echo ""
echo "To verify default PDF viewer:"
echo "  xdg-mime query default application/pdf"
echo ""
echo "To open a PDF:"
echo "  zathura document.pdf"
EOF

chmod +x ~/.config/zathura/setup.sh 2>/dev/null || true

echo "Setup script created. Run with: bash <script_name>"