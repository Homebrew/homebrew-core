class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.2.tar.gz"
  sha256 "3b271f474abc0bbeb3d5d62ee76b82785c7d64145e6e8b51fa7907b724c83eae"
  head "https://github.com/Tarsnap/tarsnap-gui.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "34d641a2f477699fdbace87e2366ad998c012915f7e64315c90be60db07b5ae0" => :catalina
    sha256 "5423a7d16f7c629fb65a3f4a9240ce388cffbeee214f40b12599abd56fe39df9" => :mojave
    sha256 "d3e5e2aeee094f0e5944d68765965f2b9261cce026bafe45482a2b1e9abb1273" => :high_sierra
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
