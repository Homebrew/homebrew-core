class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.207.tar.gz"
  sha256 "acaaee2d6dd7b4e588dfc21b9d130408281f19a9805db36a691a60ff166dca89"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "290ac74fbc5ae86435979dee3a0e14ec1121cbba70cf10c7e693b08adcc3d32d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ea2a637140c62698c82c355b2b9fc709be5dda9ae6310d25581e19eff4e70ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2028d89a240cccd793a426cc24f7769073ec5f02a2b11ead1f91284478f1e991"
    sha256 cellar: :any_skip_relocation, ventura:        "8251ae29cca7c5b831b8b35525728edf4036c7d8b05b5a77d58748294a87a032"
    sha256 cellar: :any_skip_relocation, monterey:       "2ff35106e88d1e86b702227d1138c6cde8f91242f4a4476dfce3fc7f217ea3b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d27f7ab4c16717dffcf2ffaa329a913d660a35004ad9a1ab299005037b1e03ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151e163cbf44256ba4323b5e64463a3ca54e2f35a8c75fb0d01aa4f278521d1b"
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
