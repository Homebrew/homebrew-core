class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.8.0/zint-2.8.0.tar.gz"
  sha256 "0abb92df28e61dd3efb2bcaf324588ff77e5037cac7bb7098b8da814e622639c"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "f414ac2f0445406aedb320e7bbbfc6fa5a892b2851f1b8bf5fd9eca67187ae08" => :catalina
    sha256 "8addf8406940a9c1d03f9f6397dc648a85e9ea67df26733225fa91288bc4af39" => :mojave
    sha256 "5569fb070c7d3e2308860d52e70ae0aa90976714267f53522ec6ab8f0cdb78a9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
