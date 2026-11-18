class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.85.tar.gz"
  sha256 "dfaf4856ed503ec1ad619bc76716dd59cd90949aa3279474b01a64831724c7bc"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6046186ebbc4a5c77f5e38b4ba3b6ab342f8850f6ac71bf041a40da95973f8c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6046186ebbc4a5c77f5e38b4ba3b6ab342f8850f6ac71bf041a40da95973f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6046186ebbc4a5c77f5e38b4ba3b6ab342f8850f6ac71bf041a40da95973f8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ef2e5ad7e74899d291f71a71e78de1486c574e81de2b86324bac7acf924f2e8"
    sha256 cellar: :any,                 x86_64_linux:      "3634c5341dba60f94c58a7207feb2fdfb9e2c390ac6601f77b3aae17b2eaf913"
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
