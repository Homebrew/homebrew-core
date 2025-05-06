class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.11.9.tar.gz"
  sha256 "be58e6011ce1228afa1c6ba15f33023484b1bc8673c466f186ac2a130bb25bdb"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1428b66b3f3d2c99f53e4bec1e48c00af41e16e5fe664692a48cd70e4ceb73f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2f931202207d44d4d947e1545ff61939866dcfef6061e5e670590ab909b593b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be40e9b300a7b77adaf9cee7d3197abb0559100450d0d0ffa42192284e8a9344"
    sha256 cellar: :any_skip_relocation, sonoma:        "594b7ffcdb2d1b95aecf396dee25fa74e9dea87b19aaddf558bb1c7a6b6e1116"
    sha256 cellar: :any_skip_relocation, ventura:       "6c377cac03136721c6df87656ecc300c5976785b7dbc185d6c0f967016ecdb21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e4631ba3524b8524a0ec64c70a348ee2815d971b18aee3a6a821b478c7458b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3968192f05119be2ad9e33eb70d5b2edaa38e30453c88266f726e4dcd358c57a"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
