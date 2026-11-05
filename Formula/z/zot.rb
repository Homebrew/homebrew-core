class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.65.tar.gz"
  sha256 "139eb9cedee69a75a9dc372eee0a6ea165801c21da27b9e4d7c14d7bf5cb774c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e17d99a2981a96e230a629c34a3b4214c80169570121757f61e54d410a1685b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e17d99a2981a96e230a629c34a3b4214c80169570121757f61e54d410a1685b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e17d99a2981a96e230a629c34a3b4214c80169570121757f61e54d410a1685b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5357ed6cd4ed055d5697ca83275d583e3a1602650c4ab9207f5fcc32abfddbb9"
    sha256 cellar: :any,                 x86_64_linux:      "776156182497362ea9fa5ca1cda59bf6b284866288aaed3db6e4221ee618500c"
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
