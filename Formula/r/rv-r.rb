class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3f5e6f0c5cfb2e3dc78b96e8cb596fbe6c1e7f007a4c8673986b652cd46edd02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05d0620c8646a158b2c09e8c28f304857e9ab2df33483de94e6e0d127834f084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036b3ad3b31a390c78fec8d4b57193d17071941b77ebba90ae66711f223dcd64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56acc3b934223d502176a9240a594a63ea8148c75ca54b44b498af9e1f09ac23"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b598767b8955ed753e52829b911450b7ec44fd725e19a16f6039d3b17ca7de5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13518fd572c119fcc299519fcc6a81a1e8331bdcf72665da0332fc1f56fe1175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ae7132dadb3dd9ad644920ff37bebbeac12e9c1f5ccc806abbfac2763c61dc"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
