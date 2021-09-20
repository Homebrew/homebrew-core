class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "46a7705b97d985ca3bc4ffbc47ab0bdfa14ec9f7907fee041014134b89983782"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f6ac1e35cc8ac5cf4196a76a5b9d91eb3f9d619923126e3eeacd34faedd5fd3"
    sha256 cellar: :any_skip_relocation, big_sur:       "2327bc60f9f90c450013699cb6a07d0ff65290a9d630b2ab90e4eda5baa98a2c"
    sha256 cellar: :any_skip_relocation, catalina:      "e4881b0f77e8e9432540bb7343e3ab56ff8f4c4f2cbd1f2ad78eec7fb7fdb8ac"
    sha256 cellar: :any_skip_relocation, mojave:        "152bdb2cd7eaee548d5a5113ed16c79f7053608cb976ae311e02e9f87dcb41e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022a512261214b49ce8642cc6b7eb338beda3230b88908bbfebec6af44f3c8b0"
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
