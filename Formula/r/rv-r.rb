class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "5acdfd81c134ac7b0ec33993bc8cb1b1b44e54263bdd4247737e706a6ffbf84d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68b03e77ed74da01c2893fac182b6896cd67054a0e24e6ae0b256a36c4495e23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a054b439b6ae08e1117c1a3c8bab8d3b8338777664bd44cd304cfa665505e43a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9e45f31a61d08cef3dbc9edb8db70ed50d338f006465b66383f8da7d07b54ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "1da03b85901d4e09ac57b3acc3c325561df20e5e271e4d8296d62ce1480aaf8b"
    sha256 cellar: :any,                 arm64_linux:   "ccef22798311a3daecbcb38f58097285c12cdf3917c716f3862d477afe576ecb"
    sha256 cellar: :any,                 x86_64_linux:  "3c2e74fe1e6836ad46679b691bddda0ab7a5b9e7c21df45ba8bc32ecfcba8363"
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
