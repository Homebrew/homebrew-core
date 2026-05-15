class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.13.tar.gz"
  sha256 "f34f09efe0045ac11ecb15fb300a307e4171584e100e7a9482ca942c570e930d"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17c01a2a2bd4921589c84b80a830407e51a24b0231835d759fe98fb90f79fe60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616d173f2494d9c0c70e2436b49bf8abf80cc6ac9e14f34c1669071252e48e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4a4f81c73686c08ad1603757761b2c2d84a041ff7a97c2cd26f20f12c0bf749"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad81228b877be5b419ea84d2a18672ec5c2e22c619a09f72aec33e8e43d3e12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bea24e0873cb8155f9a278787d67663e5b33cbb18bf88ac03e7d04adca13278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b107af0268261fa65c03c1f321a71abe15084d99ebfbb3be8b9d2c9f2d14370a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
