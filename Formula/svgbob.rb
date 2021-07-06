class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.5.0.tar.gz"
  sha256 "731de78542ad5bbe7400711e1b3b98ef191506b766bd36745629108356d312b1"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fbb3820afa6ae02cffffe9b90161e6294ae1917845948d371b3a14a7d2b34ffb"
    sha256 cellar: :any_skip_relocation, big_sur:       "4daeffbfb6d2a5dc8f566ec5aac40aaa0ac8dff25e48c6de963115b701fb482e"
    sha256 cellar: :any_skip_relocation, catalina:      "1d2b6de079ab8329fa255e34236adca88046a5600e9678ce5a49d2074e73a2a2"
    sha256 cellar: :any_skip_relocation, mojave:        "10e3ccd6798a3bb087d197a0220778af461ba0ce819586620ce506c868d34a7c"
  end

  depends_on "rust" => :build

  uses_from_macos "libiconv"

  def install
    cd "svgbob_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin/"svgbob", "ascii.txt", "-o", "out.svg"
    assert_predicate testpath/"out.svg", :exist?
  end
end
