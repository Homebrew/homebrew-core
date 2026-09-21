class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "17e77d4505cad0377ed880fcbfbed9ca03d7a02dc4dddfca5477d2dbf592764b"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29199a00c8f3fdf1a2da2ae2c5cecf21b0eb99da8c7bdf2ae979a92ae0102522"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7af28960ef62069b28c538bd6713156d2195e892e662f28e35e7e38ab8224d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d48365d075a9fa0a22982e4998d0cc3e616cf636e4a839257f27eb048eaf6ae2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "e9d756b359ac1e41cdaa1f090e0a015dd5918b59e9f2b73f553bddda95c9d893"
    sha256 cellar: :any,                 arm64_linux:       "37f336a869e09acb5aa9c28a7c19265c8ebc036c0128c9f540127953f0a04477"
    sha256 cellar: :any,                 x86_64_linux:      "c8653e70915bc1490676a54390f0536739e9b0b6d505d6585c0eebe3b042a9eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end
