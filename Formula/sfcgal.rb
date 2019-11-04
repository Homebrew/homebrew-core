class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.7.tar.gz"
  sha256 "30ea1af26cb2f572c628aae08dd1953d80a69d15e1cac225390904d91fce031b"
  revision 2

  bottle do
    sha256 "ed1fe60ab20f1c5dafa487779a06becd1b5ca7dd8aaac3c59dcb8460a439ba38" => :catalina
    sha256 "1fcacf1736448f1490a29abf188bb00499bef52f7dfe6d11adb7bb9f7d6b1730" => :mojave
    sha256 "be74e088dc8b81771e8ece9a79e3ba93f8338e764bb70b173ea045037d4b1790" => :high_sierra
    sha256 "49f796b256dd748214d8b2d8a954daa3b1f01c6ae3bd96bc1dff2a3364e57c63" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # Patch for CGAL-5.0. To be removed next release. See https://github.com/Oslandia/SFCGAL/pull/197 for fix upstream
  patch do
    url "https://github.com/Oslandia/SFCGAL/compare/v1.3.7...sloriot:remove_auto_ptr.patch"
    sha256 "4cc975509368df986ff634ddcf605ad6469aa01bb68659ae21d171ed2a0f5f66"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
