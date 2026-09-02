class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.56.tar.gz"
  sha256 "29345ee55f142c1ba9cdee2b53e218368a1ca7d93cc6d937972e90eb9a68d410"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "785ec90375de4e3205ea1388351a02f22d3bcefee78ee608b96f8ec15e8b7dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "785ec90375de4e3205ea1388351a02f22d3bcefee78ee608b96f8ec15e8b7dcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "785ec90375de4e3205ea1388351a02f22d3bcefee78ee608b96f8ec15e8b7dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e07eddec8350ae57447d3019f4ec128ab454c2594b7532c62699b80f104a9f4c"
    sha256 cellar: :any,                 x86_64_linux:  "3c4871ec6ae204a696ba749292e17edd607b5b212a51998ac15b73e2e1456331"
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
