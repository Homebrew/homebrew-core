class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.74.tar.gz"
  sha256 "31c179ade9524e34709835b7d1ff554c72767b1e9de459dd82bb09f3c29e91b0"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "911c04538ae2da03451b110a0c733e1459587e409523ac04ef8e0d36e3ff75ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "911c04538ae2da03451b110a0c733e1459587e409523ac04ef8e0d36e3ff75ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "911c04538ae2da03451b110a0c733e1459587e409523ac04ef8e0d36e3ff75ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9557b22579490e8dbb2608542ae99b05c54302f3b86e16ccc8efef4fadb4f488"
    sha256 cellar: :any,                 x86_64_linux:      "80211a082502b274ad6a42707f934fbb36d8a1f5b70b37e46532de7960bf9436"
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
