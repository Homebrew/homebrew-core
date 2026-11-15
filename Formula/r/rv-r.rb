class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "2237ca6b54ff40dcc9cf4ce5ad000d197f34df7631fa5d143e0f734866f3d230"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad5a1eb4c4a31072d52edcbca0c22133a2146c5f95e69a9ac94987963dcaaf0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d52ce9d6e6418205f2daa774751a6348cf77c3e811f08c6238ad0e9b9cd5778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46bbf206cfe1227dcd75ff5596eea0eff0a66b5133cf0cdb42a995d1f01d240e"
    sha256 cellar: :any,                 arm64_linux:       "b8960ee6cad732912ebb460d9b74cdb4efb5f8e4f9da7431f6166f1ef08d6510"
    sha256 cellar: :any,                 x86_64_linux:      "64a31fce5b73793e6dc13c861dcad0fc9a58f54c318672f3884a4a97e6824a1b"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
