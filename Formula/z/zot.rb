class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.63.tar.gz"
  sha256 "968dd30e6d38800e70536b8872da3739d09707db6a11bea8a9ddfc8171a01a59"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c88a78799e96b45d1b22d615ffd848685f2f7b1025364784039e884c418d754a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c88a78799e96b45d1b22d615ffd848685f2f7b1025364784039e884c418d754a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c88a78799e96b45d1b22d615ffd848685f2f7b1025364784039e884c418d754a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a2a3357debd7c29fb87889a684492405a7b4cc0a23acfaf3c1e6f25a1cad84e3"
    sha256 cellar: :any,                 x86_64_linux:      "e15723095187bd1d64b3ecf86ed6647e5cd7a92b0f440c80f13a6cd2d3e98dec"
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
