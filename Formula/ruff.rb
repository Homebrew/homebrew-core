class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.141.tar.gz"
  sha256 "5238f4f27d03e7352a6322abc3e207ac41f2b591df3a3307993c1ab9d851c316"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9dd1650c114c3f4ad450e0ab00ca93b574395d781f8aac7286b4563c3460185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac5c7a047ccc5e0e39344aba30ae1229c55f9e9a7405f079b39c8236ac817002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb709c2dec78554b9a05e4dbfe55439b366149fd7edbb53d108952d29e63a83e"
    sha256 cellar: :any_skip_relocation, ventura:        "8f814ac86bbe260476506934a18662a6dbfd373505a5736940b58c6dbf4f7f73"
    sha256 cellar: :any_skip_relocation, monterey:       "a0753c015451fde9a4a2c1382a7c0603f83b9a9a5d81d74e47d3e423f05d4417"
    sha256 cellar: :any_skip_relocation, big_sur:        "e60a21d13f62f6f2dc7b8e4f4147e3bce270624c161e85acf23fdd57fd10a089"
    sha256 cellar: :any_skip_relocation, catalina:       "c7c20f0ec99fa3c66d7cf5088ae14b5aa542f27d47a3cccb8439638c7d932dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec38036034294d7de6e0552c96f6adf35e59e22d432af95128f3d7a746e8d9e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS
    expected = <<~EOS
      test.py:1:1: F401 `os` imported but unused
    EOS
    assert_equal expected, shell_output("#{bin}/ruff --exit-zero --quiet #{testpath}/test.py")
  end
end
