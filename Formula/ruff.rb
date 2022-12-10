class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.173.tar.gz"
  sha256 "6e24b1e40bacb276a2d4364676ab3c01f086be3a62142bf7802c54016e12b6c2"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8140b701029be1568d5c699eb5491c8503cf97ca8a58ac9e4bdcd5d42f99d5d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b700f1f945323faa2bcb270efca9e1d046789106f54b7831f6b0f69dcf03165"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed7a86260ad348be45a274d3bfcedc71a9a03f991d75b4f1765cadcf1c1900bf"
    sha256 cellar: :any_skip_relocation, ventura:        "ca18ba174d5cae25165196eba452f77616b31c631dd5c9b66297e1510db37325"
    sha256 cellar: :any_skip_relocation, monterey:       "398eda98a63724f1eece072be17ae55036194e4dce087f9d66d3390d8d68d845"
    sha256 cellar: :any_skip_relocation, big_sur:        "63e45aad10301b10771d381aacbe7a3217e72a71c89def9e404ffabfc73db381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a232a10b77b4aa031b72132c9600cc825f9dd8f2286ba11bab86308bf453ecac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
