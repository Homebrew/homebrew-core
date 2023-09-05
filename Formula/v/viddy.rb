class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "fe7b0756491d6f997daba56a2363ccfde66dcf253979b0f08b0a360439a128d4"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbc7c12a15061ea6e1387bf563c77459aedce964b0bd2644ab687f347a339849"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b09b1260095abe4c76db68d3d6f7e184d7fa0fc9c43fa5d4abdbe76b38567e9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0178846dbab54c9e683e793a5deb73ac44dcb804e02e0365611c1bb5a2aa8e2b"
    sha256 cellar: :any_skip_relocation, ventura:        "b9951c6a134f22524b4b6afeefce54586560578aa69f4ac247f7edcc783026bb"
    sha256 cellar: :any_skip_relocation, monterey:       "d3adb935f90306236576c3ee12f8cc6241ec4c07816993c666c29357ad60983c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cfb28fa87544017b55a1990ea8416e5a7130773ca7ed838cb85108088baa9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67228b0ac66527bb42e7648a4c969357ed8e6dc89f43146f73d1a26e946dc05"
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
