class Yetris < Formula
  desc "Customizable Tetris for the terminal."
  homepage "https://github.com/alexdantas/yetris"
  url "https://github.com/alexdantas/yetris/archive/v2.3.0.tar.gz"
  sha256 "720c222325361e855e2dcfec34f8f0ae61dd418867a87f7af03c9a59d723b919"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf350d8daaf62f863b7466477aebea02145abf1f14e50ee56ad324c99dcee018" => :sierra
    sha256 "fd08bc62fc0c4687ed7e76fe604c345a647fb52a348c55cf446fcbf52c7af8dd" => :el_capitan
    sha256 "a14c5327ab931d7394b3f617422916eafbc76a936ac77e81a959b38aa223dd5e" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/yetris --version")
  end
end
