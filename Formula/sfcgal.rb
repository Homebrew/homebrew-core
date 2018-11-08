class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.5.tar.gz"
  sha256 "e36937d1d8421134c601e80a42bd535b1d9d7e7dd5bdf4da355e58942ba56006"
  revision 1

  bottle do
    sha256 "991c98fba3828ffab869051ee2dadcfc909f10c49fb3fa26a6df902a161c75b6" => :mojave
    sha256 "041efe2007327376ab0541aa65bcd43c3d34c0a81f0d7bfef6e981925b0a8ef7" => :high_sierra
    sha256 "2c41d34e6d241e2c1c4d0de5e08d793ce5c4a22aa5a93b1c258f62d2e0c2c940" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # These two upstream commits fix build failures with CGAL 4.12.
  # Remove with next version.
  # https://github.com/Oslandia/SFCGAL/pull/168
  patch do
    url "https://github.com/Oslandia/SFCGAL/commit/e47828f7.diff?full_index=1"
    sha256 "5ce8b251a73f9a2f1803ca5d8a455007baedf1a2b278a2d3465af9955d79c09e"
  end

  # https://github.com/Oslandia/SFCGAL/pull/169
  patch do
    url "https://github.com/Oslandia/SFCGAL/commit/2ef10f25.diff?full_index=1"
    sha256 "bc53ce8405b0400d8c37af7837a945dfd96d73cd4a876114f48441fbaeb9d96d"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
