class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.0.tar.gz"
  sha256 "7ed35439fc197e73790f4c3d1c1750acdc3044968769239b2185a7a845845df3"
  revision 2

  bottle do
    sha256 "e951bd5d493db1062b4cba7d82f12cb901080405f5baf82d20b741eb1eb53c6c" => :sierra
    sha256 "3154bb53419f7ed18becddeeebdd3e1ffc7acee49815eb4334bed277c8e281bc" => :el_capitan
    sha256 "71d17dd246841b30ac95273dddf0c56a4751240cdcb05a5d76d4d3d26e1aac25" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "mpfr"
  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "cgal" => "c++11"
    depends_on "gmp"   => "c++11"
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
