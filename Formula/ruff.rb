class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.162.tar.gz"
  sha256 "6bcf0d7ffdd8839ca0cca2c0c39707040366b06edf63727668c13fe4adcd917a"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3e1b7ef4ab20959c6bff32e193d15675a3d0f3114bf56aea3f03cbf94a62c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "717c28532de600332b2ae2e1f551f3db6e484e969847de5e1ed59e2e0ee9ae42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84b99abe4869ed934028cbdf6292aff311abbc2775012fc315b5b7bc3ab5b56f"
    sha256 cellar: :any_skip_relocation, ventura:        "5a9839140e4c1c9f4774fa61639535f6502f5964313f2e7a1de6da95eeeb3503"
    sha256 cellar: :any_skip_relocation, monterey:       "66851f570e0ce706b5a81b08aa12c61b95c451df9888e5a60ed28748ace50b04"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fff259c15864fc5a89d8b2aa4da4eb8a9563ab8f03024f3c6595f0680b1f8b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9d82bd36ed1d249afedb8eb60145c256832febef8a1d41c46bb2b4f9bcc75e9"
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
