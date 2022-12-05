class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.157.tar.gz"
  sha256 "c20b076b43f2f0c8c74ee0cdbeebfbd9b7095963ab8a108ef7f5ed01569c4c56"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7485095d8cd1bebb5985d4095cc86e316efc685d303547ab5f1b73dd06de5d23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fec3c00fc071f1ac1825653f29d69dc5b070d1f0322158d857ded06dab95b25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "760d55a6cdbf0517e7e008da6330720697f6693a9904d435a50e8d09ac7fc8a9"
    sha256 cellar: :any_skip_relocation, ventura:        "65f792e91737222d23fdb564b71d42f17889ccf907f1bf14b036f1dd191fa2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "df0ff48da9e7fd561de1d10d022c8638a9475c04e968fc668ee43d46c858bfde"
    sha256 cellar: :any_skip_relocation, big_sur:        "d77902274db40549e6f383f3a80f02fce710551cff58a9a57149fb341ff28a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9645fa5c55cd90af8a66e9881049cf602cdc1ebe7fe9fb460c00ee67ced56e"
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
