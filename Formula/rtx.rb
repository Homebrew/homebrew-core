class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.6.tar.gz"
  sha256 "8d8a8e26978e07ba272f4a81ef903efb9137e62ddaaffee2b19f1c0e8fdafb28"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e428919ebf574d0e8463f410d45db185a2a9bf3e0d04130b47e7043fb7997520"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47aaf6e3fea2ddab87956e88e175ddedcd64b69b1b7f01fbdfaa6d40b7c009d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6748c26c5a625a9219b3a816c32a2300b1decdfc3fe9358bf92f7ce7c98eed56"
    sha256 cellar: :any_skip_relocation, ventura:        "41382cf00ec5ad29b99ca3196658af7601578419c4b367e040b95bcadf63a748"
    sha256 cellar: :any_skip_relocation, monterey:       "5107ccbf3efa5f3a50764ddb5c6d65c6f52369b2fbc49f3fcc77ad2fce380145"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed309cc67ae5830a1ea996e4a788d7e930ad4ef9ce769f736e046d8fcfd9a0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bdba039225c6c2050e0360e11494a93e893b02946eea1447b8b1be604a027d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
