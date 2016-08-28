class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.0.tar.gz"
  sha256 "7ed35439fc197e73790f4c3d1c1750acdc3044968769239b2185a7a845845df3"

  bottle do
    sha256 "b6f6107ae1a8ca39310c8b7dc8f8df8a32bc8a21e16a8dd1e86009f216209216" => :el_capitan
    sha256 "2498c8ab7f8a325cc0ee257d49577135efe4dfeae302afc98c1f246b94034025" => :yosemite
    sha256 "a7782f9b49f4aeabf88786d13cfa409af9c406056ac55e28d2e45826c9175878" => :mavericks
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
