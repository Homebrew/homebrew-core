class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.67.tar.gz"
  sha256 "024b5228dc6b764612460ab3e6abe6dee44225c9d2cdf37d20587de13dfdaf62"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2856c1e6b276948a48d21bba73551241d7da1f402cfc17e37a26da572c198cc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2856c1e6b276948a48d21bba73551241d7da1f402cfc17e37a26da572c198cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2856c1e6b276948a48d21bba73551241d7da1f402cfc17e37a26da572c198cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c349295c94fef16add74296cdb4389ca00d701c45d21f2fc7c5d3b417c1ab47f"
    sha256 cellar: :any,                 x86_64_linux:      "c858aa86969e0bd01bd17d066f9f6da527340394a7e2198d0799455bce21e114"
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
