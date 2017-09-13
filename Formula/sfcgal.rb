class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.2.tar.gz"
  sha256 "1ae0ce1c38c728b5c98adcf490135b32ab646cf5c023653fb5394f43a34f808a"

  bottle do
    sha256 "ec17719a1cbbcca043f4093dc9b03635d3bc56b43ec3a9b7ab25f19706640ac1" => :sierra
    sha256 "21ce4b29006334b7bccf3f885c0fd68f5c3e80f6526921a023c7d4c90b100e6e" => :el_capitan
    sha256 "89e90fcb05ddd7fa763a1d46a0e5823c86adb52a40377c64230b89855192a1f6" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "mpfr"
  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "cgal" => "c++11"
    depends_on "gmp" => "c++11"
  else
    depends_on "boost"
    depends_on "cgal"
    depends_on "gmp"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
