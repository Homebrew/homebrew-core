class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.1.tar.gz"
  sha256 "502e53a4eacb2795bfbe62b9e6ef236cce6fdb43cb15153c0fc4ad61c161eb97"
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  bottle do
    sha256 "4fa93eda73468007493ee8313e72deb14ca57a9003eee306a6b7d1c76d1edb24" => :high_sierra
    sha256 "0d11d5065652be913f86bb6a5c7719a4af044555d3cb43945d95c0803cec6bf7" => :sierra
    sha256 "2ee9b8d041e5a9aa6dbb4d95cfbc120ba6e4df4d1072c1442bfb8c4fdfca5231" => :el_capitan
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
