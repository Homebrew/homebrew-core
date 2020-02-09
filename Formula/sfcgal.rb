class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.7.tar.gz"
  sha256 "30ea1af26cb2f572c628aae08dd1953d80a69d15e1cac225390904d91fce031b"
  revision 2

  bottle do
    sha256 "fefaaab69ba9fc4664303b558c01a9bcc584fbe39b0d34e2373d384c4a371e2e" => :catalina
    sha256 "e69cc15c8b93ddd06a9c65acd55afc338d520939d8781cbe97d8238548eee380" => :mojave
    sha256 "58cd7e79ae765402b421fc1f4a6b7fd3b9d9e4a54bfe06fb5687b6b886c25bb4" => :high_sierra
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
