class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "1cae38a9e4cc3eed0280f913ff9339d76f471b0d8acd983b8d662bf961c0c477"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f45e6486cd078aeba24da5b446efb77452f36b043c38e3c4e130cde3e7b2327"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "effedbf20d4fa6e3e449a8acac588009994dce00d69698046db08c49ab0a5a83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4889f42c58c7761dd51def045a254a7ba3a4223c45876e01fa671ac22cb7871"
    sha256 cellar: :any,                 arm64_linux:       "bc134170486bb65b22317e83afa03c0d2473cbcf6a4a7af3e0d01c099b1f7476"
    sha256 cellar: :any,                 x86_64_linux:      "e4901620328fcf998f56400a7142b1a9fa0d793b33c40b126c48b1703fa64697"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
