class TarsnapGui < Formula
  desc "Cross platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v0.9.tar.gz"
  sha256 "e47e1e611f2c7bb5111bcc1d2d86fa2c045ba4af23f8430bbc3c72f546572cb8"
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  depends_on "qt5"
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
