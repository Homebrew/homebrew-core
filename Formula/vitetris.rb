class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "https://www.victornils.net/tetris/"
  url "https://github.com/vicgeralds/vitetris/archive/v0.59.0.tar.gz"
  sha256 "8a3fd7ad6cef51eb49deb812d2bf2c9489647115fdf95506657cf9d7361b1f54"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "4518d9cfdf14bf52d3c00203cc03cf5890edad59c1710d33db2afcee4c30c678" => :big_sur
    sha256 "17c380c39ba763e9559876cef2a6c5189947994aef7c0e6f3613e383f8f9e646" => :catalina
    sha256 "5cfebdcea81b5e7720d1941f3973b0b47c1fd510234b09f81e9098c1132c0b92" => :mojave
    sha256 "175da9ed672d62d7c5409d94f299a67ab8499020283a4ea1ca21f6efc6470809" => :high_sierra
    sha256 "6cb9f1f8d9492c7a652d32115ae488dd19282aa94261957115b50e97c74f06f4" => :sierra
  end

  def install
    # remove a 'strip' option not supported on OS X and root options for
    # 'install'
    inreplace "Makefile", "-strip --strip-all $(PROGNAME)", "-strip $(PROGNAME)"

    system "./configure", "--prefix=#{prefix}", "--without-xlib"
    system "make", "install"
  end

  test do
    system "#{bin}/tetris", "-hiscore"
  end
end
