class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.68.tar.gz"
  sha256 "862e4995a3f5a2a37f200281d5c1241f356c96c7c262d62241897356916d4d41"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "802dd10e68c95985b56e2820b75b123d63c2e5e8a0675fda3def42bcc8c0c04a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "802dd10e68c95985b56e2820b75b123d63c2e5e8a0675fda3def42bcc8c0c04a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "802dd10e68c95985b56e2820b75b123d63c2e5e8a0675fda3def42bcc8c0c04a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14700d69ef23ff2eae4389c18950a753cb129815180f1653bb026a42fb2dc535"
    sha256 cellar: :any,                 x86_64_linux:      "bc3597061b22039a98678311608cc0c598d38e530b2f4a6afc95211824f8685b"
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
