class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.181.tar.gz"
  sha256 "8291563d7c3811b3783ff8b6a0f87c2bcfea6d9f0f8c984c3ddeb148f1d5e411"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be27c92ccba3bfbc8abcfeac34f062f1aef082b8755d72a2d45e0ca0a969cddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cdfe11da6360c3f1469aada92710ba2ccb2508351217cf4829f11afc72c5be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6e747ed663c728deb447ee87b59d63081618d0852694fb5eef2163e5bc4c397"
    sha256 cellar: :any_skip_relocation, ventura:        "c0fcacfe7ebf56b2541588a2507d4751e5700e554a3e4813eed2fce869ad8274"
    sha256 cellar: :any_skip_relocation, monterey:       "0247516e1df2739109189062776fbcc65215d0cc39c8c8734edd0df0eafea297"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdfcd854b3423d7bc81a382a740acbc60b64693900e519e732f0837ec438bd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a2f40921cd82a2b8d9d65bb3845c681ef6de72f1f8a4ce39ba950294eb2ea05"
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
