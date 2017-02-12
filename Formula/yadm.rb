class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://thelocehiliosan.github.io/yadm/"
  url "https://github.com/TheLocehiliosan/yadm/archive/1.07.tar.gz"
  sha256 "39f3974c7d8f3930b9dee00d5b1b2181976e60a4e2cd26c35597951c5919a4f6"

  bottle :unneeded

  def install
    bin.install "yadm"
    man1.install "yadm.1"
  end

  test do
    system bin/"yadm", "init"
    assert File.exist?(testpath/".yadm/repo.git/config"), "Failed to init repository."
    assert_match testpath.to_s, shell_output("#{bin}/yadm gitconfig core.worktree")

    # disable auto-alt
    system bin/"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}/yadm config yadm.auto-alt")

    (testpath/"testfile").write "test"
    system bin/"yadm", "add", "#{testpath}/testfile"

    system bin/"yadm", "gitconfig", "user.email", "test@test.org"
    system bin/"yadm", "gitconfig", "user.name", "Test User"

    system bin/"yadm", "commit", "-m", "test commit"
    assert_match "test commit", shell_output("#{bin}/yadm log --pretty=oneline 2>&1")
  end
end
