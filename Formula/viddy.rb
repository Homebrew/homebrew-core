class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "459d3ea43436b523e654f1f60356ef3150606ed17ca88895f54b7ee5999292a1"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bdbc431b54d1935fa3836ec33a1ae90ff50271efeaa6f28337be44ea0fb391c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48df406e12194974132caad19dbc98533b9d90515b773c4621d603b00b0116ac"
    sha256 cellar: :any_skip_relocation, monterey:       "34ae8b3d8058038dc2bd2b54e1876ca8e2948afca967d7892e0b9d64a5ba798a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d816b2374bc130a7d8ed126462f14b4d12eb865f625951410dde28831fad2a9"
    sha256 cellar: :any_skip_relocation, catalina:       "8800bb824553becaf9c2a01241f161ab0b12eab06acddfb5039260126403e453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761d112defa7f61b42b6a42bd3985b3376c1d785b50c30084585f9928d436b70"
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
