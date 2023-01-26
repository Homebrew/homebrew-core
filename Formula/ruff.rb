class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.235.tar.gz"
  sha256 "58957e98d8354d247acfb9152705ddf678eca9de902d298ddc0c5eb1eac00801"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef138cffd6237c43e9a01e25b6921fe9ad44572f54fe342858f4c01d1ccd334d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5b45631bd90c82096cd5b7506cecaa39f4e39d3b07f2cf9788b9053eb9b006d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfdfa8e64dc8ef41abe24e864cd955f3fcfab9987e200186931d389a38f055e9"
    sha256 cellar: :any_skip_relocation, ventura:        "d9ae37cc2f8f15211d1ab86304578805bd77eebc0e0ddfde86b92b5cb3612c32"
    sha256 cellar: :any_skip_relocation, monterey:       "fedba9acff793947281913ec834962f3dd9a33740e3c1ba389c9c6f459f808c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a7679525808690676450a75e1efbb2578bd9a60707d210eafe199a7037a36c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ec02b9a492a61c64fd05340cbdc20555e03fcd0bd8524d544c5900d7e8f4f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "ruff_cli")
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
