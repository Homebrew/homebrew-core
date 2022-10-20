class Z < Formula
  desc "Tracks most-used directories to make cd smarter"
  homepage "https://github.com/rupa/z"
  # Please don't update this formula to 1.11.
  # https://github.com/rupa/z/issues/205
  url "https://github.com/rupa/z/archive/v1.9.tar.gz"
  sha256 "e2860e4f65770e02297ca4ca08ec1ee623a658bd9cc1acddbbe5ad22e1de70a7"
  license "WTFPL"
  version_scheme 1
  head "https://github.com/rupa/z.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c269df17bf038e3dddaf71a2fed2dcef583e5b3f0869fce963e3cae0b3524c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7709d155cd48933c2d72b4de368972a8925c45100da27739f1a41121c9882abf"
    sha256 cellar: :any_skip_relocation, monterey:       "b430e19a35c4b0e3d887777d20f67c315c246c2dcfbb0ca8bd7799412d4d9b25"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f9c920ff5f5e5d8e0f298e94ecb18d62c2605451c67a5d5ba8a2a318dbd1b6c"
    sha256 cellar: :any_skip_relocation, catalina:       "3f9c920ff5f5e5d8e0f298e94ecb18d62c2605451c67a5d5ba8a2a318dbd1b6c"
    sha256 cellar: :any_skip_relocation, mojave:         "3f9c920ff5f5e5d8e0f298e94ecb18d62c2605451c67a5d5ba8a2a318dbd1b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7709d155cd48933c2d72b4de368972a8925c45100da27739f1a41121c9882abf"
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
