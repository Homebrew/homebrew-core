class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://gitlab.com/Oslandia/SFCGAL/-/archive/v1.4.0/SFCGAL-v1.4.0.tar.gz"
  sha256 "5363c4e4a4a75cfbd6c4e9c5ba634f406db400be0afd7cafc92fddae7453b486"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44f6644ec30918f7a23a345fc07904419744378353837ce49ee2d39aa6617c06"
    sha256 cellar: :any,                 arm64_big_sur:  "b809fe115553e7ffa0679bd2402f1994cb01a98e646a775c6dfe8ae706566d89"
    sha256 cellar: :any,                 big_sur:        "e69bacf0f31e67adb7a5abc3fb358f0cbb2c1406f664bd5683c4f16241392d7c"
    sha256 cellar: :any,                 catalina:       "16d0494615f89ec1f418d1e817e894972dbd6497387f2cf714ae9edabac5d3f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4bc96070f584bbbef5fec11b51ca187cbb2d1be4a60efa9d29ea6e7203a939"
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
