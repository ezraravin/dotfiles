# Arduino
echo "⚡ Arduino Setup"
yay -S --noconfirm arduino-ide
sudo usermod -a -G uucp,tty $USER
sudo curl -o /etc/udev/rules.d/60-arduino.rules https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/60-arduino-avr-core.rules
sudo udevadm control --reload
echo "✅ Arduino ready"