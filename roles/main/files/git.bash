# Undo your last commit  (in current folder), but don't throw away your changes
git-undo() {
    git reset --soft HEAD^
}

# Clones git repo and cd's into it
gclonecd() {
  git_dir="$(basename "$1" .git)"
  git_dir_resolved=${2:-$git_dir}
  git clone "$@" && cd "$git_dir_resolved";
}