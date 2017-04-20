class TarsnapGui < Formula
  desc "Cross platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v0.9.tar.gz"
  sha256 "e47e1e611f2c7bb5111bcc1d2d86fa2c045ba4af23f8430bbc3c72f546572cb8"
  revision 1
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  bottle do
    cellar :any
    sha256 "bb526c0fe2f6c19b2b825d70991ee8bdf9a8339f1d8bf7eaf4a8f504889f253a" => :sierra
    sha256 "f72516666ca6a140f327066d08999636151340500b22fb3187eaf7ffa5f4898e" => :el_capitan
    sha256 "e9876f9b3b0476333ef46b08e92e236e31fdf0a501ebb37f4b766cbf426653de" => :yosemite
  end

  depends_on "qt"
  depends_on "tarsnap"

  def install
    system "qmake"
    system "make"
    prefix.install "Tarsnap.app"
  end

  test do
    system "#{opt_prefix}/Tarsnap.app/Contents/MacOS/Tarsnap", "--version"
  end
end
