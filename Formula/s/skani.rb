class Skani < Formula
  desc "Fast, robust ANI and aligned fraction for (metagenomic) genomes and contigs"
  homepage "https://github.com/bluenote-1577/skani"
  url "https://github.com/bluenote-1577/skani/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c8fe23ffae0119aa79cc801ac08dfc33862c94006690074daff274d937f1f786"
  license "MIT"
  head "https://github.com/bluenote-1577/skani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c83611da7900e969ed4ba2651621130534d5bcd24da8c2668f32d61d46aaf70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1edc78f45779992e62612f9295c3779d28c55e2ced9613b37438e13c48831ce0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2544b02bbaee647b988221a7b1e87d90250042bea4aabfd33800419bc3b6aa2c"
    sha256 cellar: :any,                 arm64_linux:       "15c4e1bb1c01522d3c252401b842c286fe511dca2d26d8d3cf3b86cb4d64d098"
    sha256 cellar: :any,                 x86_64_linux:      "45d72315fa364ab82e2665acb8d1697d794a75d2b185f4a6abf3083bcc172e9a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_files"
  end

  test do
    cp_r pkgshare/"test_files/.", testpath
    output = shell_output("#{bin}/skani dist e.coli-EC590.fasta e.coli-K12.fasta")
    assert_match "complete sequence", output
  end
end
