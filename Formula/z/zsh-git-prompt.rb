class ZshGitPrompt < Formula
  desc "Informative git prompt for zsh"
  homepage "https://github.com/olivierverdier/zsh-git-prompt"
  url "https://github.com/olivierverdier/zsh-git-prompt/archive/refs/tags/v0.5.tar.gz"
  sha256 "87e5a908369f402e975426ffd61a8800f1c04c0a293f1d4015a6fb1f4408e77d"
  license "MIT"

  bottle do
    rebuild 1
    manifest_sha256 "3f645767039253d401392e508d0e4d5975a2f83e9bcc5b83d6695c6d7aa2b130"
    sha256 cellar: :any_skip_relocation, all: "a2808fdcf382e27b8cec87840d95e6bbc55b8766a663bc58060b2a6831081bd7"
  end

  deprecate! date: "2026-10-01", because: :unmaintained
  disable! date: "2027-04-01", because: :unmaintained

  uses_from_macos "python"
  uses_from_macos "zsh"

  deny_network_access!

  def install
    inreplace "zshrc.sh", "`python ", "`python3 "
    prefix.install Dir["*.{sh,py}"]
  end

  def caveats
    <<~EOS
      Make sure zsh-git-prompt is loaded from your .zshrc:
        source "#{opt_prefix}/zshrc.sh"
    EOS
  end

  test do
    system "git", "init", "--initial-branch", "master"
    zsh_command = ". #{opt_prefix}/zshrc.sh && git_super_status"
    assert_match "master", shell_output("zsh -c '#{zsh_command}'")
  end
end
