class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.3.9/SFCGAL-v1.3.9.tar.gz"
  sha256 "4f8ecfaa0d9ac5d8d7969f767ce3abadc7cc64059a11481e4bc497f04d5f6598"
  license "LGPL-2.0+"

  bottle do
    sha256 "8cc583e706bc2755d61c362afbdd0cc627c6126113d4d6c5c0cc1f1bb62e8dfa" => :catalina
    sha256 "4137e3e9b3058a0d05a1ef9a357f0b22d4e0cf57ea6c525b3c4d7e3741a6ba86" => :mojave
    sha256 "cddd030fa1e55f74ee70068d2ac5b6c748def91794a82cad87a3025078cb2f78" => :high_sierra
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
