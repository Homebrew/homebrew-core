class TarsnapGui < Formula
  desc "Cross platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v0.9.tar.gz"
  sha256 "e47e1e611f2c7bb5111bcc1d2d86fa2c045ba4af23f8430bbc3c72f546572cb8"
  revision 1
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  bottle do
    cellar :any
    sha256 "3b967bcd4e194af4d7a884104e42f16dd61f6d047917311b2529269cd6839fd1" => :sierra
    sha256 "d2af74a0e60b0aa2b50d593f6685d1e99c8fbdf1e8fc300914a7a29b7204085e" => :el_capitan
    sha256 "411049cc57913952cad2ad40bdb2b60e8ccb0e26bf46136e34baa9fee5fc4eee" => :yosemite
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
