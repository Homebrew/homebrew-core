class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.72.tar.gz"
  sha256 "6beedb0b21a36d29614e1a2b348cf83bc1c2d255cc737ecbe01a933690bdf700"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "953cb3f7133e4bde6f080a7bb34e4d54a88bbe696587d77d2c69867b8c713f86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "953cb3f7133e4bde6f080a7bb34e4d54a88bbe696587d77d2c69867b8c713f86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "953cb3f7133e4bde6f080a7bb34e4d54a88bbe696587d77d2c69867b8c713f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d71b1ab4350c6974034bea68b59e91b39af4b23304bb18c04afa71371dd7b2b1"
    sha256 cellar: :any,                 x86_64_linux:      "69554fb20aa04625e46c17e1ce08b6f5bb0edf076699823c655d9739709d5940"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end
