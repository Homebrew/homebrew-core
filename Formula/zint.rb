class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.6.3/zint-2.6.3.src.tar.gz"
  sha256 "adcaebeb2931163a567073644c8e7952430ea31e08060363432d77cc599318d8"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "ede8253010c8b2523c7f4b097d5d0b4e5bfe4164fd13041690e3e8179b2add1b" => :high_sierra
    sha256 "d6df75c981b5e66e594b7890909fa64a3c40d761a0bf20a78255f54c443ec0d9" => :sierra
    sha256 "89e62db21897ceec3a49c4e8815fdf91fd135ca6ca08938027c1d9d6f1b4fb50" => :el_capitan
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
