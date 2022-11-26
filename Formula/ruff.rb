class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.139.tar.gz"
  sha256 "b076734e065e2c990cde7134bdff4691a9726598209489bf89f22a7d8d117ffd"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a3ee732463b3a0ca9e5964ed36219e8d67717db3af28583f154a159843e07a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cb84684b1a7892cd1a95211b6b7c2e15314b2156fd53e5133741d0e63af5e6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "009db5f562deb7a58381de27f131e980c059dda4137d0cd48b0f9d6ec385c4f8"
    sha256 cellar: :any_skip_relocation, monterey:       "af7879a0d1ceb2c5b1b18cca25516ffcabb2000b56cb62e065a960d51074daee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce12261c643633d496a37c5a58c477230ff990942d6e0f0596191416212751a6"
    sha256 cellar: :any_skip_relocation, catalina:       "7b3e4e4b195a751b024f2c93caa7d2c5084d252f2579b387676ac1e3cf108923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42091e475b83336b57121d2ec2fe96f8b0e2cfc21769ee963ea0eddffe0704e1"
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
