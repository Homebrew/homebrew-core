class Tlrc < Formula
  desc "Official tldr client written in Rust"
  homepage "https://github.com/tldr-pages/tlrc"
  url "https://github.com/tldr-pages/tlrc/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "17dbd30e1656da906b594d4d19ccccf88f1b4a76e63c97614267430843d80d45"
  license "MIT"
  head "https://github.com/tldr-pages/tlrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe0bc6c932d0a2385886621817ca19c9d486297844ba1792c3d4efbd5c663402"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a6d976edbbd4f97242002213acfe41a8aa58f7994a578f2bfd270bde48a01e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad48f88827ea05a65123c2a6e74c5ff74a2bb46938cb6f29b3437b328703470"
    sha256 cellar: :any_skip_relocation, sonoma:         "71373ba24c4959f8efc4cd25ffaa0a036acf0a2fbb900f4204b48d992cfe99d1"
    sha256 cellar: :any_skip_relocation, ventura:        "f60e57ebc168952b3cb83a76ee328c3a3c0da1fecb92d16c111bc78431fa4db5"
    sha256 cellar: :any_skip_relocation, monterey:       "6b31bf6612cd22a3f0e6cce1813000c2af97c07d5a029f6b7fe9dfab4d692c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d65b32448358b6d78d2a6eb14f0065d78d168e16bfabedc57d74f5fdc848c3d"
  end

  depends_on "rust" => :build

  conflicts_with "tealdeer", because: "both install `tldr` binaries"
  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "tldr.1"

    bash_completion.install "completions/tldr.bash" => "tldr"
    zsh_completion.install "completions/_tldr"
    fish_completion.install "completions/tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr brew")
  end
end
