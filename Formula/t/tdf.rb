class Tdf < Formula
  desc "TUI-based PDF viewer"
  homepage "https://github.com/itsjunetime/tdf"
  url "https://github.com/itsjunetime/tdf/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f9cdcc89e03efdb002938428905ff6cd9ef7ee9941f7b4fa1f473f9f6c49eb6e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71af477984bd5fd4044a11b7afa2bedff0342a2df7d93030420db76423d11c55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5985bc9a56f4f4696d5eff6f8a37ea6f5fdffd510daa23f1b6c66c33e24d99e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8eeb7722344129bbe2d2160367309b153dc9996a1f6021458cebb18be189d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc012675f38e4527878b57e0dae33686247d935d52c667b9f6cd3ffd403389ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc2a84e9d8137753f349d99f999d809a53186a1e6d395a6a8613fcbc912d450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b320db5f09b92f3f7c18aecc704eb04c4266b1c552468f09cced90209a7b0d2"
  end

  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdf --version")
    assert_match "Please specify the file to open", shell_output("#{bin}/tdf 2>&1", 1)
  end
end
