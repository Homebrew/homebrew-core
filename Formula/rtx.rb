class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "340dcf9e8f64504ce97c681a66c67a20cc027f01906bf1c30de74c1952c6a22a"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c6ca849aac8b105e33f27e776a4278493564d62ef52d1a11ad83432ef1cd3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de3893b5a4951bfb2907ee5513b22656e45e519f4f19fcdb441286ba71d9f7c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "046b28fb720509bdb98efb25e26761e6ef0ea099e78e0cf2b195a8d3bb115652"
    sha256 cellar: :any_skip_relocation, ventura:        "f36896de9a839f41d80d9f3e4f5f6277c2d35da31b0e2344b0df7eedb2b4c704"
    sha256 cellar: :any_skip_relocation, monterey:       "c5664467545e692839dac8ac2c34b56b22ffc0d11e4c1f98e13e0e0e1339422d"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa2fc480f7d2531b9eb3415adf79dfadc89f786a9ca5d25064b2bb25ffd188e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a354dcb5328d3feef9e232a419aec338b24650952e38d7084a8485a79294e82c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
