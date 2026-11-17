class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.82.tar.gz"
  sha256 "7e578fe1c81e1059acc4acc00c544d99a7d3d1aa7dd3b992367e83358526b1fa"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57cc3f029a2e6b2b4497634f01c5e5d5111f6134cb5bbd66e7f6508286c5d815"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57cc3f029a2e6b2b4497634f01c5e5d5111f6134cb5bbd66e7f6508286c5d815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57cc3f029a2e6b2b4497634f01c5e5d5111f6134cb5bbd66e7f6508286c5d815"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "03c44b0c702797d486b83661140ab5a6155aaa62c96706903a270940e2c60350"
    sha256 cellar: :any,                 x86_64_linux:      "a831024d8298d2cbc636c66ba1669f1053a4d00652e86fab788268e2ba2c5f1a"
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
