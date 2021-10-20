class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "76d5196e33931cc51f209cbfb22699fc000e70e168ba901ed8663952baf015c2"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1c4e5817f0684e356c2ab09828f76b0d05c0e034408018fa3ae0479b5f4b1849"
    sha256 cellar: :any_skip_relocation, big_sur:       "a41c2e1195882c2f7742d534b28f0bb43677b262e0e5a66ff8e556296a039f37"
    sha256 cellar: :any_skip_relocation, catalina:      "1f7190c3d2f026fb06a7b12e1345be3b564de5265d29fadbe89b3d3995869882"
    sha256 cellar: :any_skip_relocation, mojave:        "6f0d8ea45e9a44c3da562a7e0b7ca230517cc9fd4ab153fe6521e4e8988355b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48522eaf53c20f2b5d9fe96cb28843962039d27686c065e0c2eac301aff8fce1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}")
  end

  test do
    on_linux do
      # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    ENV["TERM"] = "xterm"
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/viddy echo hello"
    sleep 1
    Process.kill "SIGINT", pid
    assert_includes r.read, "Every"

    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
