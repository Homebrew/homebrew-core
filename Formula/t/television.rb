class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.5.tar.gz"
  sha256 "bf65e03a5484fef5010a390b9ad5289bfd5addc71101ced971eeecfef73197ab"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6898c04cb3f7992423712ee0b5ca7fb414e18246babe6b4224ec78f776cc45b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c581305858546f634985894e900fcf215ff707092826032010e035e20a7cc627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13cf4c4702af47b007ca9e15c4c2595127418ac24af51501e894348e98274652"
    sha256 cellar: :any_skip_relocation, sonoma:        "897727f4a05ae51abf0ae17d7e224cba052b04966dfabd83fd0b32bce46f9084"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7849eb87b6d6c44a4e68d0e09b209f99a2a041d68593ea628607af7cfbc286c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec16485b9e7dadc2b260be9536beb90023cb0bbe50b395dc2c7d29871c7ea400"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end
