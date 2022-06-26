class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ce000cf3fbea3f4d6ade7bf464a91d4f3fa2f3b3a7abc8a09de1e83ac400b9af"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6593301bbc4859baf860c04d922ab5bde0b6d0b3995b0eb47e1c7c2a2c7ad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cc9734785cbfb8679d5f3f82b9c6481816022d5538a6643fb405b74fcff17de"
    sha256 cellar: :any_skip_relocation, monterey:       "479cc379428291de254acc7040f3a57caae15e9122a1f412bb02f783f8a4dfc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd1830ad9935bab7e508cf7a568665305f973fbb41b8034da6a3d402915e6b79"
    sha256 cellar: :any_skip_relocation, catalina:       "1fa73fbc6b226134d3a38630b479aa198187389966810764d9735583db53cb42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61891d78333dbaf09f2dd0f2d85b18919821693bda62473d90eebaa81f26ded6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    ENV["TERM"] = "xterm"
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/viddy echo hello"
    sleep 1
    Process.kill "SIGINT", pid
    assert_includes r.read, "Every"

    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
