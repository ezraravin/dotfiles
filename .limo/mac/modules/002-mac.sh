##############################################
### System Configuration
##############################################

# Input settings
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15
defaults write -g com.apple.mouse.scaling -float 1.05
killall SystemUIServer Dock Finder

# Dock settings
defaults write com.apple.dock persistent-apps ""
defaults write com.apple.dock persistent-others ""
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.controlcenter BatteryShowPercentage -bool TRUE

# System identity
sudo scutil --set ComputerName "eRave"
sudo scutil --set HostName "eRave"
sudo scutil --set LocalHostName "eRave"

# Security and power
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0
sudo pmset -b displaysleep 60
sudo pmset -c displaysleep 60

# Display Configuration
brew install jakehilborn/jakehilborn/displayplacer
displayplacer "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1440x900 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0"