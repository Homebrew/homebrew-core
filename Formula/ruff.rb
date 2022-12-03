class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.152.tar.gz"
  sha256 "be457c95c2681da10495ea2821dddb6e3a767ef3be305d2406100b351bcd7c98"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b789ddc47b4790ebc71254a0d07c547c7bb7a6fbe1f4f320e5823171448cca18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db0a742694c317a06e2c1027c75781d781dd82f358ea3373428e11d7e0d6e1ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c67bbb0c2a26b7ccbb2b8bad1686540ee0010d2040b9ac0f7b64f17ad970dd5"
    sha256 cellar: :any_skip_relocation, ventura:        "babcc6759f3b4d661bdf56400db831e17f34b91fde8cdda3ae34d5d5cf345405"
    sha256 cellar: :any_skip_relocation, monterey:       "e82c7c253e5d1dd0a5b69e8fd9ccc863993ab44f889ebffb6adc0ce134784a6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e64c46c2873ef339d7c89fe5cb5e6b1db47b4e556897f514b5a24c8d24588a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379891b2f5c3b646b5a98a4c2fed4e1cca777a50e6204f9f86ba67c7339ad1e0"
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
