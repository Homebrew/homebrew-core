class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.83.tar.gz"
  sha256 "4bae1e7b1b7316c2bef98e394bab4770f602cfadd4862a82bf3e79014afeeaa6"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cf359703bf8d02225bc700cd63a26a3e1b7b7e02200fe8245da282fa3b88da4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3cf359703bf8d02225bc700cd63a26a3e1b7b7e02200fe8245da282fa3b88da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3cf359703bf8d02225bc700cd63a26a3e1b7b7e02200fe8245da282fa3b88da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "24171237f2788468b3b0aef8efda62113058ab02f652c1171490b8c57799b67e"
    sha256 cellar: :any,                 x86_64_linux:      "1ae8040dfe75ba9357c53bb0eb4cdaaf6fec1df32181951158945b496ec62ea3"
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
