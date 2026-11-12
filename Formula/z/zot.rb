class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.76.tar.gz"
  sha256 "aa44d31c15533a872837abc7114d4e3eba68033614091bc4164d26948a67575a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58d4d55241656cf5992e7eb2d55a60e74532f45195a413916c0bc5d0bec00aaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58d4d55241656cf5992e7eb2d55a60e74532f45195a413916c0bc5d0bec00aaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58d4d55241656cf5992e7eb2d55a60e74532f45195a413916c0bc5d0bec00aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f8efd90128a4ecf898012f42af1fef4871096e8974fa50d54d8f2737555b458d"
    sha256 cellar: :any,                 x86_64_linux:      "5a6aa52591359c3ed3696d482f0a43021d7df51711753368b016f7ac32e7b3ad"
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
