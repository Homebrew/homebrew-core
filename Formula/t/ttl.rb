class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "5b8dd00a610106b3651300c82f8cb5a463bc634d314d7bc33125229258ff65fe"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2bdbad9d1d2e706adfa4bde8b625ad205a2055c9c6f333f18e9a47fede30e704"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8610aefca05614aa580e442d7645f0c976d5265ea4b268726b8a6816bd93baa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32e3a4201d706cc8610ba0a86ea17f035c9a96ed58bfa4b81a99673334d8957c"
    sha256 cellar: :any,                 arm64_linux:       "bb6b9e4f9a09343db0b07fff72b588d253c951a1af54fcce30ab86534a728e52"
    sha256 cellar: :any,                 x86_64_linux:      "b826ed15fe48aa510a9b6141e699304e3f85b2b4647b565ec0e7eefdfce77a9e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ttl", shell_parameter_format: "--completions=")
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end
