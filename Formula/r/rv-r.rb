class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "2be443428dff4122dea7df9f62b62167a01dd67675e72e9431b536699e9c8a05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8208f5eb25dadf851340982200032787f5247a1bebaf5f28702760cd1cbc0878"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "04e2fb04f9bd0b7d04cf72b5fd8a5a42c9ed0bb5c2cbdf6afb67447cdf339255"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "71c4e7d7f5860a069972e0555a40337f01a7183fed6fea92a6c0587df7c565b1"
    sha256 cellar: :any,                 arm64_linux:       "65b5b926d865fb5c9dfb3d78cbdd18e021c843d6ef5ca2b9c00dedef4b41c044"
    sha256 cellar: :any,                 x86_64_linux:      "5d5ec16356eb5d4fa16eaad73652647ae6ca7c7803213be32247b58a9670cbfd"
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
