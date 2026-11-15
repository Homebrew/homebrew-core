class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://github.com/lance0/ttl/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "cb646a4a6dce6d5a4cd6913559a04a04a67fa06de539fba9314aaf51cf28275a"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01fdbc89f70227cb381c8aea20993e32c74dd399fe49b96525877cb649a2712a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "540482f91198db1b75c439836879ae38e6f6a5fba3eb0f2ed9e7cc317e233836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10939ac76a96b9358d1abe0d56d6591e144ebee334c424c822e65cb1ec5135a1"
    sha256 cellar: :any,                 arm64_linux:       "af46357a80bf9d081bc0cffb7a9b946cd131ccd1aab372f4fb3b3f5f053b00a7"
    sha256 cellar: :any,                 x86_64_linux:      "8d2fe0ab62d49214a4c3229b5bd4e93a0e8827f05c778d75f540ca71ffdcc22e"
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
