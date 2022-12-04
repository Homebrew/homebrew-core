class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.153.tar.gz"
  sha256 "2abc4df21ee5f161fce09f28b63d16506521310617e6b2ee678d34f75ccab040"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "658fd2f9b46985867d7213b2906bc9df23fed0f5a9b374477be570d8d6a9552a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53301c11c6ab5ebc0aa2206675af387d9377301efcb0220299aabf041223856a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9299fd42fc0f5a73506420a24add4deb5f5caf8c28ba9c01e21be97f59d5588"
    sha256 cellar: :any_skip_relocation, ventura:        "a60cd685bf82f308b21b187e52c88a20df3488c3eca8a528a7052e6f94ea7dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "cd41153683ec43fdc4cbb3bc649f9699997ff2ab82c4427edd00658d30738ad7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5558da89f713873afec93163176d56ef4b90510485c4c8f65d797e4a1c462bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ed4be2415884f1c196dabcab462fddf16d56b0a54f1fe1cd4951901f6d959f"
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
