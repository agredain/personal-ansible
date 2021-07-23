killport() {
  echo "Killing process on port: $1"
  fuser -n tcp -k $1;
}