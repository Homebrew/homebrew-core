class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://zint.github.io/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.6.2/zint-2.6.2.src.tar.gz"
  sha256 "bcbaad61f64bf9153603fe453924038aeefabc62c674a178b4af9dd95a779530"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "9b8f1d855612eda58bda591f1acff56d0ece37271089476724bedf8b8815abf3" => :high_sierra
    sha256 "4c97ab4ebc7659744ba54c3a37402a3baec7c9726d42b7976b6cb07b08a7ef9f" => :sierra
    sha256 "0d17d6cc0d330cb09dac162a8a56b69f97195761d26414b9898742af3ff35d9f" => :el_capitan
    sha256 "8f7447588b730925be6f5e4d366a03394046933b1ae9ce6aebbcd102c8898d77" => :yosemite
    sha256 "bfbd68636ae952c6b4bb27ac6eadfca425ea5658be708c1152baa0d336d6fce8" => :mavericks
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
