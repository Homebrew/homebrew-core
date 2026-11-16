class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.81.tar.gz"
  sha256 "27ead9fe792ca4ba59965465955c25708da4239438544e8b7668e4d2d4b3365b"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a36a613e37aa136323e6c7e0612a66b2ea4021961b7f9d467cdf6caa8696105d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a36a613e37aa136323e6c7e0612a66b2ea4021961b7f9d467cdf6caa8696105d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a36a613e37aa136323e6c7e0612a66b2ea4021961b7f9d467cdf6caa8696105d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76bd9e39ca4e12ea5515dd14c6fa4d88f0a0a39d158bd0dc156e86f1b70d25b4"
    sha256 cellar: :any,                 x86_64_linux:      "3e17f3893def072bf974ce7b0f1958b4c6ade60659f0973e1978e9d69f2ca869"
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
