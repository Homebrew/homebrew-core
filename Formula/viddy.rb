class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9a66db51e729713df102def0c2c02b786bb09c2b024204c515f9c0dd721382aa"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c40201dfe64007d2bbb080fdcd4ea212c40bb757200ee3c336f9003de5b67461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5424a7740add9505a202dff137df1692d3254b04ed16c3d8a74ec14d35545525"
    sha256 cellar: :any_skip_relocation, monterey:       "d91f15be6d4996d1bcb5a9774bbfd119076e6aae544824b44662eae2d255b4fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "e54f04c85892bee2abefc7911d371e25c0fa4d1fa4f8d4b513b75c334514333c"
    sha256 cellar: :any_skip_relocation, catalina:       "f585e2d1ff4d12846621b75ec961509fe7fde4d68a38d77db05d6bc789385ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b789c7ee5bc37b63aaf80df52bdc62e774c5ae76ad93f3198de18710274a330"
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
