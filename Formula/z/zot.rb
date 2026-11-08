class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.67.tar.gz"
  sha256 "024b5228dc6b764612460ab3e6abe6dee44225c9d2cdf37d20587de13dfdaf62"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c280e50980d8d9e2425ede73922b7c17da8b2b25339ce3cdc04f91662595c1c0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c280e50980d8d9e2425ede73922b7c17da8b2b25339ce3cdc04f91662595c1c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c280e50980d8d9e2425ede73922b7c17da8b2b25339ce3cdc04f91662595c1c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0561f4bad70dcd1a09db904c65dff8f5b2abfe67e192067c70bcc2e33054978d"
    sha256 cellar: :any,                 x86_64_linux:      "4762eb25bff0a1bd8f0b2c868bd2c68f78b3e51446dcbcb67a69714e6a247b0a"
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
