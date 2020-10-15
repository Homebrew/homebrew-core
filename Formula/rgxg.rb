class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "https://rgxg.github.io"
  url "https://github.com/rgxg/rgxg/releases/download/v0.1.2/rgxg-0.1.2.tar.gz"
  sha256 "554741f95dcc320459875c248e2cc347b99f809d9555c957d763d3d844e917c6"
  license "Zlib"

  bottle do
    cellar :any
    sha256 "4a07550d93bedfa3b2ac3cb77a8484951321697ca9384d2c2a0301ea261aa954" => :catalina
    sha256 "b410fe9ea150e0fb52326e4f7ce6642f946098b0713c5741c64699de3f55f762" => :mojave
    sha256 "286318be76fc55c094da739c44176d5babd814df1e4f0462711aea283db042f5" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"rgxg", "range", "1", "10"
  end
end
