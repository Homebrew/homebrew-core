class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.62.tar.gz"
  sha256 "56e06d7c2f44c2bc8d04a36550aa6d53491857f3aaeef8f9b9bc49833164b08a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73c927cc2d5e5eebcc6138c82801599c796a4163106521f5cebb634eb98afe62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73c927cc2d5e5eebcc6138c82801599c796a4163106521f5cebb634eb98afe62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73c927cc2d5e5eebcc6138c82801599c796a4163106521f5cebb634eb98afe62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb6dc3a87f4c68a68fc485e6a7989a6fff761c93e3ed2267c8d8b4ff719821c3"
    sha256 cellar: :any,                 x86_64_linux:      "4bab66bf551a3c0ac89a564e75b1750377fc80f62e23abf97911f320289123a9"
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
