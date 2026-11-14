class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.78.tar.gz"
  sha256 "5b4564a5f84851b26736c0f59aa12e176a62ad87bfb467548c22809821ba559e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d9a3b4853c1a7e23ccbd9e5d24db1675e0ade1d3e7e5d1f50d2b4538bc9c21a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6d9a3b4853c1a7e23ccbd9e5d24db1675e0ade1d3e7e5d1f50d2b4538bc9c21a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d9a3b4853c1a7e23ccbd9e5d24db1675e0ade1d3e7e5d1f50d2b4538bc9c21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cc5cdeff7bae13d6b36772aa9e6f92f8df8923932947e9c2823a3f743c9596aa"
    sha256 cellar: :any,                 x86_64_linux:      "a0a81a3abdddddb29326763f1fa12b8c19cc0b2204948f13f0b043ac4ec28fb2"
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
