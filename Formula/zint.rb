class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "http://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.6.7/zint-2.6.7.tar.gz"
  sha256 "07f93d94bfa4a98d685a97a1c1744d162c14cd93cacddc2eb898676eeba5ea19"
  head "https://git.code.sf.net/p/zint/code.git"

  bottle do
    cellar :any
    sha256 "681b6b780fb9f1b6db231beaeef90cd831ca4cb67d07b0c393e3c88a4b89ef5a" => :catalina
    sha256 "22fcbf433bb9e66f391196a6b89c7ff684bdba636064701a280517d0ead898c5" => :mojave
    sha256 "2ad7667eba9a78b385577ed7c132eca79e425f20098ae90eefd38f4fd1786092" => :high_sierra
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
