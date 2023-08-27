class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.8.8.tar.gz"
  sha256 "0503655deca1fd8e4e11e709f8a0b61f0b52a7d8de89b1fc6c88ea8a23d5aaa2"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4627b645e90a70e2d013e070ce3698a0d18ccb032a973b4f3755506ce5ee906"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d36cd2d7ea4094f9fde051a4980a4f3c493c50f84e48d5cadd3e040f19a0cf8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65b77dbe43bbf2352c88caf6dfc9005ce3590cf35205cd621ed01398c6fd6691"
    sha256 cellar: :any_skip_relocation, ventura:        "8e646cb7562b7ae148175306dd5ef602e81a6a6f505c5f92331e46cb25b1a0dd"
    sha256 cellar: :any_skip_relocation, monterey:       "0d22f13eb3645bdd68a0fd61227c53e414cb4533316aa2d9e1c703d8848c07ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "d72cf57b7f1f730baf1f0445ad848674c6b1724ac5f414c13d596afdea0277a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd6d4846b38363507512b323091a971278d201ca6eef3277adc92c2fced1d3b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
