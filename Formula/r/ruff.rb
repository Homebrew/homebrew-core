class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.285.tar.gz"
  sha256 "9477c8db1f5d21cc53b038a40748e97e541c9356926c45bae15767c5dc56c91f"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc39d7ae6bc7a796007ee1ed98481413f7bd4529a8a0026cf0baeefba069fa3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ed050d2d874fdf45406fcf68eb47320ca345a098db148c13bb10202442a124"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2360d33cf9db4e47f8b1905b177398780a7d23d8903205ec24540440081fd535"
    sha256 cellar: :any_skip_relocation, ventura:        "551994a196c16d86c67f8e1f76a6599d4ee7215b22ffcbcdc103b7acf93cad7b"
    sha256 cellar: :any_skip_relocation, monterey:       "ce9c41c3e1a1de59e568837513552b05ad1181ae6920c161d7c3d420e77595b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d54ef9b8a210a35cc2497659730ca56edc5ee99e39b305a7344c5520b997cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051478e168a52e23bdffac1a8daa3b44712eb0072a06a364f72b2df49258a998"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
