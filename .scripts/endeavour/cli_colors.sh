# ANSI color codes for colorful output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print a header with a message
print_header() {
  local message=$1
  echo -e "${GREEN}"
  echo "===================================================================="
  echo -e "$message"
  echo "===================================================================="
  echo -e "${NC}"
}

# Function to print a section with a message
print_section() {
  local message=$1
  echo -e "${BLUE}"
  echo "--------------------------------------------------------------------"
  echo -e "$message"
  echo "--------------------------------------------------------------------"
  echo -e "${NC}"
}

# Function to print a success message
print_success() {
  local message=$1
  echo -e "${GREEN}✅ Success: $message${NC}."
}

# Function to print a warning message
print_warning() {
  local message=$1
  echo -e "${YELLOW}⚠️ Warning: $message${NC}."
}

# Function to print an error message
print_error() {
  local message=$1
  echo -e "${RED}❎ Error: $message${NC}"
}
