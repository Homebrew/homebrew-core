class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "459d3ea43436b523e654f1f60356ef3150606ed17ca88895f54b7ee5999292a1"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94203d619dfa11db244cefeea6407b657809ad1758b2b9b9edec988c02ad775c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ed75fb4678c69f4b17e60b3f7d5d79062f9842d407065c5b8eea2f45408cb46"
    sha256 cellar: :any_skip_relocation, monterey:       "35004a320ef6ab389a7172546f4b99e56474868fd4cca70a89d39c4b008be374"
    sha256 cellar: :any_skip_relocation, big_sur:        "42683c3e7bbb2f3b9d9d17e48375ce6672a8b365f3a94f8c833e5058337c33a4"
    sha256 cellar: :any_skip_relocation, catalina:       "b904656d10800778f242c860c550d5da3508a51d735702c1f779dfc2f3b657ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41afacff33d7f52feda350cfbffe22634cd903e7c141ac8277933d47746417b7"
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
