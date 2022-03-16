class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://yadm.io/"
  url "https://github.com/TheLocehiliosan/yadm/archive/3.2.0.tar.gz"
  sha256 "bf5868187fccc9df78512dbdbaff079ecd2d9ffcfe77c4e567587c8e12b45a30"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65aeff364d8b3ee35a44a19631f827da7e1c777852030f1912c7efe727ce9f06"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "completion/bash/yadm"
    fish_completion.install "completion/fish/yadm.fish"
    zsh_completion.install "completion/zsh/_yadm"
  end

  test do
    system bin/"yadm", "init"
    assert_predicate testpath/".local/share/yadm/repo.git/config", :exist?, "Failed to init repository."
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
