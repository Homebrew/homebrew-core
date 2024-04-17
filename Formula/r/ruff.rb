class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "3adb76aebeb24c2358f51183fbe7a981e0d45c11af2afce6ca67f985dab3b900"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73fde7ae4f139afe76dd2cf701d0a4a88acccd3d22ec631e617b3929ed67bbf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e2429a3e51e4a880558ee0b8543c0521c529132211f2ead106682f08bdd131d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5e1acb247f286e0ea23e471985a0f68b9277c030c547b75ce1927c5343074bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "967dd950de1844b87c20813ea0aadf5f61dafe6426714931244bd915e0f3478f"
    sha256 cellar: :any_skip_relocation, ventura:        "449dc4124a1c9c9add2f2c5794df2875a8c27015bee05867235e794898cee9b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d59fa7ef035af36d2c52e2fb22499f95422a51d073f655203f55b0aa2acb719d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6735bf78699715883669686c294309c3e82d787a5fd6964413a8660257de2d1d"
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
