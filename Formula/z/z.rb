class Z < Formula
  desc "Tracks most-used directories to make cd smarter"
  homepage "https://github.com/rupa/z"
  # Please don't update this formula to 1.11.
  # https://github.com/rupa/z/issues/205
  url "https://github.com/rupa/z/archive/refs/tags/v1.12.tar.gz"
  sha256 "7d8695f2f5af6805f0db231e6ed571899b8b375936a8bfca81a522b7082b574e"
  license "WTFPL"
  version_scheme 1
  head "https://github.com/rupa/z.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b418e43748f1185408f2e948df304a58d662ee0ec41489ba5b603f56e24bbb6"
    sha256 cellar: :any_skip_relocation, ventura:        "0b418e43748f1185408f2e948df304a58d662ee0ec41489ba5b603f56e24bbb6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b418e43748f1185408f2e948df304a58d662ee0ec41489ba5b603f56e24bbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
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
    testcmd = "/bin/bash -c '_Z_DATA=#{testpath}/zindex; . #{etc}/profile.d/z.sh; _z -l 2>&1'"
    assert_match "/usr/local", pipe_output(testcmd)
  end
end
