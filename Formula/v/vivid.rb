class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "a43ccfbc6554055181a08f2740664f9280fa2d0e57c4641850c60dd0e5323720"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "398963cabbaf8702745b26fe4ea1f77a32a230718a2b6087d7120d4a4927b23f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f3bdc717cf987d5e8fe657daf8dd8b2fcd24701735bdcd60cd6d7d9dc71214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3e4d6c6481c22186c95ab36753d4a44804f3d8515017e48a4ca667664b36f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e95541e49042260c75c278311a5777acd11e76a1cd7af9067436f625083097fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40ee40be6c6955cefe4f766daca30a2582c71d76080956c238ef0cc57347892c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c2e96c2dc332c4ebf0cfb2c928bdd7daeedee4e40375ef490085ecc2ac0f83"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
