class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "ce000cf3fbea3f4d6ade7bf464a91d4f3fa2f3b3a7abc8a09de1e83ac400b9af"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62a7447fa383b03f9ad6e003fda62d6d9f781ac3d427ae4159febb7a05053ec7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c846602958e6024387f06f8f0880dda5d88b602d7f4110c2e229c22acc95be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22a18c5c21fb1c5ce0ebf14061f927bdd5921e4529be58e2355a2240a8e4567"
    sha256 cellar: :any_skip_relocation, ventura:        "045456f1f1340b2599c2511ae1aa637365afaaff032154152825694a002f76a1"
    sha256 cellar: :any_skip_relocation, monterey:       "33e1f39e65d3c7738ca59a003b50edae7f2193edd6419f57e64572b1c3c7b7fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "69648be7ff74b5f2d18bff1402670d3d73fcc12be3aba9c7ff3e0b9cce99a257"
    sha256 cellar: :any_skip_relocation, catalina:       "c76670a6fd66fa6047fedc76d8c79d65e268a744ab68e0bfcd273358462c43bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af22bf94ca5359083881ff25aa23f6c0dfbd5e7d55eac7030591b244500fbb5"
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
