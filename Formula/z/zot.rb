class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.66.tar.gz"
  sha256 "a8a6bf98146c93293cce22d9affaf59868f9377fd56a5f737aef270775e7124b"
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
