class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.89.tar.gz"
  sha256 "84b3f2de74c9202e5edabe31d7c93faef27f3f1d1fe422a8028589803c71c210"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    manifest_sha256 "4d90652f4a8229c46fa0d63f0c177132d5b3e2e7c0cce48e6915e7acc82689b4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2c64793101cb7e1d36790527f4737e4375e922c03d2061b81e1caea15964225"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2c64793101cb7e1d36790527f4737e4375e922c03d2061b81e1caea15964225"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2c64793101cb7e1d36790527f4737e4375e922c03d2061b81e1caea15964225"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "548a61f09ae53a0752acb5e3da6383724e288dc8c3eb39336c0e5a4630e01def"
    sha256 cellar: :any,                 x86_64_linux:      "fbba9ccf96d097d7c05b6476454d8c8116f33eab312e2ee800203267366ea500"
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
