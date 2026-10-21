class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "db1fd6933ad07f01029c5bedf3c6ccd485683eadf8e875564552f0891142f40d"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "030bf84a71de5df73f88e049c13f82c8ea23b54d18645b309e8f6dbf602d0d23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c024dd50fdbec0c36bd3200361ae21f8f1e06bb29d31791c471af52f96994617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d9c728c96de83719ac1e018550e691a18fde78c634e9230f6cae582e6c80694"
    sha256 cellar: :any,                 arm64_linux:       "ed5b6e690aadb51d456ed24507ece61f2e9f60ec5b5482c403e33da372201c66"
    sha256 cellar: :any,                 x86_64_linux:      "e1fcc7cd56f0942fedde10d35ea91ba84ee4995e4106b3071ac276242a63ef33"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ttl", "--completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end
