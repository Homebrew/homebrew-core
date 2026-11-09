class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.70.tar.gz"
  sha256 "22b456c4e2589aa1ace60c641e47112433c544239eedf114623a58ffbc29a8a3"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5b7fdcbfa491e4935ba14e3494d81efe612ce64dc246ce523e9f3907ad90ddb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5b7fdcbfa491e4935ba14e3494d81efe612ce64dc246ce523e9f3907ad90ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5b7fdcbfa491e4935ba14e3494d81efe612ce64dc246ce523e9f3907ad90ddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee0518bfaeb473709854490c70eb98d5b1c123f1add9b4a9dde93dc188478a18"
    sha256 cellar: :any,                 x86_64_linux:      "1f7eb625e414f2f4bb46ba5b84530c7d5809a8c65845497d274e631be4b353ad"
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
