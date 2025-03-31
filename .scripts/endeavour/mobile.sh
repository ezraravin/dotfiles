# Java Development Kit
echo "☕ Installing JDK 21..."
sudo pacman -S --noconfirm jdk21-openjdk
echo "✅ Java 21 Ready (OpenJDK)"

# Flutter Environment
echo "📱 Setting Up Mobile Development..."
yay -S --noconfirm flutter-bin android-studio google-chrome fvm
echo "✨ Flutter Stack Installed:"
echo "   - Flutter SDK (pre-built)"
echo "   - Android Studio"
echo "   - Google Chrome"
echo "   - Flutter Version Manager"

# Flutter Configuration
echo "⚙️  Configuring Flutter..."
flutter --disable-analytics
flutter config --no-analytics
echo "🔒 Flutter analytics disabled"

# Post-install Checklist
echo "📋 Next Steps:"
echo "1. Launch Android Studio to complete setup"
echo "2. Run 'flutter doctor' to verify installation"
echo "3. Use 'fvm' to manage Flutter versions"
