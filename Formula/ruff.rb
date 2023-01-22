class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  # ruff should only be updated every 5 releases on multiples of 5
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.230.tar.gz"
  sha256 "f55f2caa68b9f841eeb475763040cf10085a0dd29f89f2183f9c6a440e8b5c03"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95e6233e559a48cdc41fac297857cefd16c766484af65dd0109e18424f2ca52d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de17dda56438a6bfec73b5cda280ad3258888f21138c577063fd40c126b47a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6506258cb92a7508199aaec361b2ac4a94fd3ceec11355e91d33126c9eb1037c"
    sha256 cellar: :any_skip_relocation, ventura:        "bda8cbc0e6dda3fd245e44773e0bbef8798827326123df6fc07c22c967da5d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "108fc6db2cb680c2ad59e88b7b2b07c2ff955cab9ef5d3701f0b0e30de4902e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf21430100c4a0dad0398db0c38bdc9cd9b95377a21b793b548b1d9f39f60349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f037afe61760db56f2cc0c76205931f7e42954fc1d7a1c334379489b8328e1d8"
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
