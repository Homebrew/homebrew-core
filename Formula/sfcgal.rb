class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.5.tar.gz"
  sha256 "e36937d1d8421134c601e80a42bd535b1d9d7e7dd5bdf4da355e58942ba56006"

  bottle do
    sha256 "da85122b3ce45845eb493be9aed24e1c57f4b40aff6afbdffb632fc956796019" => :high_sierra
    sha256 "4a903847c590800f80d216fbb2ec068e821a080b6ad9168082b0a1414092c6a1" => :sierra
    sha256 "34131e15890a6869322ec73702f4c651e9e58033ce035865241b34209b82231f" => :el_capitan
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
