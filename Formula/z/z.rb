class Z < Formula
  desc "Tracks most-used directories to make cd smarter"
  homepage "https://github.com/rupa/z"
  url "https://github.com/rupa/z/archive/refs/tags/v1.12.tar.gz"
  sha256 "7d8695f2f5af6805f0db231e6ed571899b8b375936a8bfca81a522b7082b574e"
  license "WTFPL"
  version_scheme 1
  head "https://github.com/rupa/z.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "8d048cdf7dd88dfdfe1e89e73a842fb91e743d6e0ec6c60fc99607e0c3d511b0"
  end

  def install
    (prefix/"etc/profile.d").install "z.sh"
    man1.install "z.1"
  end

  def caveats
    <<~EOS
      For Bash or Zsh, put something like this in your $HOME/.bashrc or $HOME/.zshrc:
        . #{etc}/profile.d/z.sh
    EOS
  end

  test do
    (testpath/"zindex").write("/usr/local|1|1491427986\n")
    output = shell_output("/bin/bash -c '_Z_DATA=#{testpath}/zindex; . #{etc}/profile.d/z.sh; _z -l 2>&1'")
    assert_match "/usr/local", output
  end
end
