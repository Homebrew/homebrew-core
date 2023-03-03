class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.20.4.tar.gz"
  sha256 "8ed6c693bf57a35355b1f5c5337b13616d95072dbdfd8f437577c3aaec465e18"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "293ed5ca2279f005916853dd9ae5ed5591f15d27a5b1b1a5973cca93eb3abebd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad55e08447dfedc4bf6e9f0ee1be64df194ab685b67780e7cc75b553a963c28d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f06fccaa816e8bed261738d0bbff3e86ccf18d4e0e7b230a8e65cb00ee3c285f"
    sha256 cellar: :any_skip_relocation, ventura:        "faf0f4d4bfcd794b6cb40b88d3b7baf5aadc4d39e33fd169792c21d5c5fde3cd"
    sha256 cellar: :any_skip_relocation, monterey:       "339b955d474a00464305824c6c4f2770d239ad9a977e3036310cc6f4a1586241"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3c0a9b2baf5c8fd80d16197e06c419c356d4872d949b96bbb36489469ce45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d58c36dbd59c9d0cbe5b3a3be2e62f56f0afc62058338b1237a66cb5fd91df"
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
