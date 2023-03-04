class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "ebfc8c65febacc450f59a6e475fd8a969e81d3da3d5604916dfd7279ed62abd7"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd4c30593692f6bae8debb413aaeed3586a079146f85b39a0164c447302a6e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c696dd0c576e8380e361110c17483214e74096fb8a9917f5a4f06ee936c5d5dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c701be6bafe613ef29dd2134c43156c36365048219a4f60bbdcf63aef1bbdce9"
    sha256 cellar: :any_skip_relocation, ventura:        "367dc317dd9e68e2bc202c378ee1106935c0a26259e4d0a44cacc8266d1bd3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f7332a0607db2c884b2f567ca07bace5ad362159b9d4b27c520e405621b539"
    sha256 cellar: :any_skip_relocation, big_sur:        "75996825457c5a03e53ae834df8a9d3468e81bbab8ba2a906298c558ddd56545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87fc3385c19570e62f26180822e1ac061acf629c8e22ec707f6555e53998731d"
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
