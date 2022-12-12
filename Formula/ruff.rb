class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.177.tar.gz"
  sha256 "47f1db37aa5ef7379f10e924e54a5774125812bc05d76195e26b3d4833db66ae"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf14d1250ffb5029da47c144a3e0c6f5a71178de88440d446383ff9adc5a48dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ded1548a9f6de2def9ab159782609ca9d786f9e30760e563c4992f0e7e88ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f13a205d9ec38b9a58d5efdc8ef4a3269ffa11d059ed1359f8b302139d0406b2"
    sha256 cellar: :any_skip_relocation, ventura:        "e0044cc77a5260b2b662653cfb503811241b97508c2892761c687292ef54c141"
    sha256 cellar: :any_skip_relocation, monterey:       "cb3a4bd0ab6b1852d8496e2a6f49aa9122facc83d1d5877dcb335eb00d7e17ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "e865a286ada0570751ae2572030371cc7061282a5980ecfc3826dedf23ae8a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43379a9a334773995bd90aef10a8f91719c57feaed0ad3132c1949eb1062f8e"
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
