class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.38.tar.gz"
  sha256 "6d839e1e865a530cf2f81e1b52825c092fc29e84485f3bce7bc11f629e39888c"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f853bdab1df6237a940928a0188a3004c81f9bcdb003021704a8975d592300b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f853bdab1df6237a940928a0188a3004c81f9bcdb003021704a8975d592300b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f853bdab1df6237a940928a0188a3004c81f9bcdb003021704a8975d592300b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf45a85dcc57d827665fb21d593d7d62f1a5ec542cf04faa53672bf2bebdd791"
    sha256 cellar: :any,                 x86_64_linux:      "e6c631ba1545c754caa145e3e563eafd8af24beeb6c96356428704cd066f904a"
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
