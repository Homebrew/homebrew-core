class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.12.4.tar.gz"
  sha256 "865bb706ffea523652668f2f00e6cda7c75185e9bd4e73dfe959047b2f70a6d0"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25e08309e188db94106503354cfc10be3b0b248b9d3b2d80266c4cf9bc817d7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "718a9398eecc93ba0b1b5f4f708a39dbdddf72df4210c63cfab4c170c3ad5422"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a26b88cb7503856f9289c7c300d2aef66cfd7f93a5b175a669f81b721af94f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "155660bb10ad891607c9794e2caba6a74f4a6c29c17d3276c247e9ce65d555b9"
    sha256 cellar: :any_skip_relocation, ventura:       "062d0b54dbc5d3c9dc2ade882b54d836123499820ef5e9ca03a5cacaf1aaae20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6b0afcd899cac376efcd5782ec182155f0f106e90632656ddb8b3ac58fda2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d338852c5bd4bd9b9d79f6a712982b056494acd7a0ef098cdb05e1b9d5a7f0e"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end
