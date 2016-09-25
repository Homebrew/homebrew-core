class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.0.tar.gz"
  sha256 "7ed35439fc197e73790f4c3d1c1750acdc3044968769239b2185a7a845845df3"
  revision 2

  bottle do
    sha256 "cc73f1c6b4b2ea0a6c648ef1090a6251fe00888949a4d7fa2785d7066fcf7ae1" => :sierra
    sha256 "2a854bff305f9c31c98ec96dbb84b99609fed5f3db89d93dbb82cd5133f550b9" => :el_capitan
    sha256 "3c9e06176d0d24d0039761fe8e03dbe3d2008b443d15ca7e943d575e142c571e" => :yosemite
    sha256 "6b6eb54eff2cc0ec85ee50632cf678193651c42391a488701f342685527ce23f" => :mavericks
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
