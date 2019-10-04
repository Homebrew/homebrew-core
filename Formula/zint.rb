class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.6.6/zint-2.6.6.tar.gz"
  sha256 "648df79cd48b45e5af75b72385d1a5a740f178178d988fed3c37aa7e59bef541"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "cb5636c433b062d562207afac08d7200bea18e26aafc9840955df3ea7aae51b6" => :mojave
    sha256 "f74d7d1b72fe284fc2a980e1a2ccf5cc0559e004064d451eeae7147dcbe9256f" => :high_sierra
    sha256 "c9183fbd6c0f0cbe7b4fce3091608691b843e089411e072b053662af9f512905" => :sierra
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
