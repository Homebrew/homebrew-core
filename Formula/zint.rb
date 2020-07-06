class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.8.0/zint-2.8.0.tar.gz"
  sha256 "0abb92df28e61dd3efb2bcaf324588ff77e5037cac7bb7098b8da814e622639c"
  license "GPL-3.0"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "73fd531d68666227d575947fa5c5d4e1c32c1dc8f904ae4fd8bdfd622ca447d9" => :catalina
    sha256 "1548af77a2e17959409fb6873f81fdbbe5ab7c8db3e99bb4c944849aa7656632" => :mojave
    sha256 "fc47d148dcd11a920bbecbedd35fac8b58ac1fe95297b9cdc234a8d8cb2a9746" => :high_sierra
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
