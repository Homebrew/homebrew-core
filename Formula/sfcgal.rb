class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.3.tar.gz"
  sha256 "57e0237b328b519ef0e274f0a24b4c266e9d5541214a3911bd68fe861a01240c"

  bottle do
    sha256 "3380ed48c72bead389f7e848f264a2c2c6bb01d63d80484fbfaa6eac8eebdb7a" => :high_sierra
    sha256 "aba97c9f2c5e1e59c68313d75a749d7574c8acdb94859bbe929d9dd877876dc4" => :sierra
    sha256 "f4f703ad4c673da1f98097622f9e6e80e7545df0c71547ca280f6c046c5abc57" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
