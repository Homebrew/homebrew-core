class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.2.tar.gz"
  sha256 "3b271f474abc0bbeb3d5d62ee76b82785c7d64145e6e8b51fa7907b724c83eae"
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  bottle do
    sha256 "c62f584809071d3dabf02cbf29d788b4f86e6fcd5996293d30377d26f141971d" => :mojave
    sha256 "41217f384ad4c1702c2ba93d7f97c24b67294aa6331c9a16900455e3a997ca6c" => :high_sierra
    sha256 "ba85a52b227ea1bb947f970e5f3926057b44560a3a562356558f7009535d31ab" => :sierra
    sha256 "b0fa1979fa2cf1ee3b56e1060c7d9e5bcd4c9319104adfea4cf1fd279ae80518" => :el_capitan
  end

  depends_on "qt"
  depends_on "tarsnap"

  def install
    system "qmake"
    system "make"
    system "macdeployqt", "Tarsnap.app"
    prefix.install "Tarsnap.app"
  end

  test do
    system "#{opt_prefix}/Tarsnap.app/Contents/MacOS/Tarsnap", "--version"
  end
end
