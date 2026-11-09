class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.70.tar.gz"
  sha256 "22b456c4e2589aa1ace60c641e47112433c544239eedf114623a58ffbc29a8a3"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e31928f7f09b77242d6d8f16d7090b1056b8fb119dea9b4b51066a48cb4ed3e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e31928f7f09b77242d6d8f16d7090b1056b8fb119dea9b4b51066a48cb4ed3e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e31928f7f09b77242d6d8f16d7090b1056b8fb119dea9b4b51066a48cb4ed3e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b768492de36bcee0cab7a045ab337648bfc929f0a7ce1ec49be1ffe35966b5b8"
    sha256 cellar: :any,                 x86_64_linux:      "22654204c914cd24865622c600813d5b3598af2799a99d9f0089dcfaa43c83bb"
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
