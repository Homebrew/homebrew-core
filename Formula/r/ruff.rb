class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "12dd075410eb8c73865048817d851fed617e0d8baa30d06707b8b67ff25e247e"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32a2168335468f3fdb5de7805c4589656cd067803b2779d5962e3fa8bd687dfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f8b4c9aaf0a1e097ace33e988fa6353171f180d108353bc5bda138e36bdff53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cac7456da1942f4854606d808b5e1c2180ead26f54cf5c3186535185af2a8843"
    sha256 cellar: :any_skip_relocation, sonoma:         "d40e7d2a3026111b6d3f650bb72c6944e372fb4ff30564acf155947301419d27"
    sha256 cellar: :any_skip_relocation, ventura:        "e5da25a98c54114478a6f013c5c302cf7d1f1f8e5d2d144d772a5f96a39d25ff"
    sha256 cellar: :any_skip_relocation, monterey:       "f917df401f6bb9ad27cea253ef9a59ffcbbe918a9ed23ca6b9020cc004982dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbe7ae04e598e8243707f7a87d814e6370a4ae7c2cd90ac71252100a105cfdc"
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
