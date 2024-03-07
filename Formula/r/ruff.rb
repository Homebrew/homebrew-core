class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "0102df567ac89bc4e1517ef922de363e1604e60309e4d62c9b2b977847ca1ea6"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c143ecfb623542a9781f01538df596e5ba43cb1e6260fe51ec649007960f7b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b7fb3fcda1de0d790aac4f3bf3c1d49a6bb1122bf90da322ac1d6c655f5c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c410d7ff6c7a1be99745832e12fb361e2ce995b64bd08c9055fc677a27be1b95"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f29a5e45e8d46e9de5784e594a34ea74ff82f733582a14f5ce54c3cab83649a"
    sha256 cellar: :any_skip_relocation, ventura:        "3f72a1f0c6d7cc34879905336431122a71a8554a55b2e1e4aa0abe8e46f4dec7"
    sha256 cellar: :any_skip_relocation, monterey:       "caa471c76fd802f23510f7945b1beb650616d8dd73f921139ee166feaa72895c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfedb44b637347f697c9d168f60b7949e25b294fa71ff3d22253b2d2292643bf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
