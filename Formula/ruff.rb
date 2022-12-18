class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.186.tar.gz"
  sha256 "3e7167225e7e0124584b8745eb68b6b46015ef2d23cccd85608b4685ac50a26d"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62a3ec6dbe4779feadebdf57d91b1f4f2022588ed1c185a86b6e4be230c046fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dae26facb3d162564944e7d46f2125fe8169fe342974a8a1694943a507736b23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e2f39842e53978c9f3474c306d2948dede1171b670189fa532961dfc04ed027"
    sha256 cellar: :any_skip_relocation, ventura:        "e2139f9938b7a93fb32729327bac17b5931a0600a41c6371f529837db766b4d2"
    sha256 cellar: :any_skip_relocation, monterey:       "dcfeac1ba254d89ecc549dd3cf292fae20ed6420b5f6afc3125160bd0c5ea207"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a2fd0878a291b0280838f043631609012c51162e85c11576b8545dad97c756e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d782fc48c43af0d7b06eab4c2deed7e44eaa568bdca16462fcfa4c2937635221"
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
