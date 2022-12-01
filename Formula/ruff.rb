class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.149.tar.gz"
  sha256 "be46985f8557c02830ef73c5f562acf799852ff57c1e7a8c9e4fe81872961e6a"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77445c41a344a5bf1ffc7c2c45bb58a938782d5ffb1d46826555197808e2a81a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55d9fdb2ba5cd52ac7b83e685c41dc3b69fbb22629fb6e6b7a52cdacc2363ba0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a0d02841f3cc6506cdb9a62a5cae17ef6c348dabfc7386aa4fb46dfaf67d591"
    sha256 cellar: :any_skip_relocation, ventura:        "4f21506a988925926addd56368109239910c4568717e8d48ad002c2ff2a2c4e8"
    sha256 cellar: :any_skip_relocation, monterey:       "ed96d86d2cdd65d9b0c3b262c0c1230aeee432a2eb6588c39d52ce74c0439a1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cafeff3bfa85fc3797c107f142aaaee15411cbbe55dce518c6faddaeda5d550"
    sha256 cellar: :any_skip_relocation, catalina:       "1a3241cb370c723a4ba13bb5d2bd8fd13a849e668221c18b4cae345edf50eaf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00473e31bbfc850f6a278f03c79c8a7ecf78f9b8c900112974816b9541f6ce3b"
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
    expected = <<~EOS
      test.py:1:8: F401 `os` imported but unused
    EOS
    assert_equal expected, shell_output("#{bin}/ruff --exit-zero --quiet #{testpath}/test.py")
  end
end
