class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.166.tar.gz"
  sha256 "75a43476fc02a6c68718de374348b5c5edc15cd35b14e08b1404e6c0d37da86b"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b211f914ae295b22c735e140438645d0b6212bbdcf12183bbc24778fbbdcffd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28058e997634a47ee2d50fe915a4ad93cf246a8fa29f62253c43a7a0a78f522f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70e87abd5d63d6ab41e35e2d0440bad810acbb572cfdb87a0547189a13f65471"
    sha256 cellar: :any_skip_relocation, ventura:        "c179acf2532ccaed624b66cb6e5ac1a0dc0ce52a3ee3a3b1cf718e131d2eee29"
    sha256 cellar: :any_skip_relocation, monterey:       "fb589b5e0fcf4ac96c40a903f29b9599b8e7fe185ff45bd291e1de87e906b974"
    sha256 cellar: :any_skip_relocation, big_sur:        "de95dcc428d5e84d0828fe3f09dcca89e5bc4715d61974cebe24a1293c3fd771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937a84716c8893d07871d65a01c72be8f1650b522f4031a01abcbca703e13f3e"
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
