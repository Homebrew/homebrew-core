class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "e3e2f88707f0ce22a329a91f2f2a2e2f33a5468470fe076c15357328156300a5"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7b2ff4f2b8046d6b37322da2c1811893c617d0ae39557760047948f6f4c1cea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52618a4af684c200cd9222b807784d76dadaa9dd535e97359b02fbdef68e88f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36a46d7390d0b4a8804571fab9b3de22e3ec97860c2c0bb56b07988712c83714"
    sha256 cellar: :any,                 arm64_linux:       "61ccac67c35311982bb94ba946353ea7671d5db65d90b65539fe475f5973cc76"
    sha256 cellar: :any,                 x86_64_linux:      "67e1e61db609fbf2d4a5d8000b2e3c0c19010da9164cd5ece416e2a5b88d4569"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ttl", "--completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end
