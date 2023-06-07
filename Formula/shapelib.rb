class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.5.0.tar.gz"
  sha256 "1fc0a480982caef9e7b9423070b47750ba34cd0ba82668f2e638fab1d07adae1"
  license any_of: ["LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://download.osgeo.org/shapelib/"
    regex(/href=.*?shapelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c693a38da6fa7633ca03d6e2cf5e7bb5d32cf9d606bb1a4592bdccacc3b2456"
    sha256 cellar: :any,                 arm64_monterey: "26b130368d9849bc2931523dcf1ea7985a88d52acc2709ce570f3503f2ebad44"
    sha256 cellar: :any,                 arm64_big_sur:  "3f95046988d245291a4fb9973051b5c006500ba3ab0bf2842ae330c18936bdca"
    sha256 cellar: :any,                 ventura:        "07d4c243a8c75a0a26c7f6ec87476d49cb9876e7dc963254181c75c3d54ff2d9"
    sha256 cellar: :any,                 monterey:       "6a14fe3a6e76220a19e356c3b3c9bd64be88e7fe69a013d088c9ef78f31a83b2"
    sha256 cellar: :any,                 big_sur:        "dfae7491c46ca8ed8b587dd6dfa885b4ec6db8520095b1f1ae44becd28ca76d2"
    sha256 cellar: :any,                 catalina:       "9800e87eaeeca3eca0d59c3bca555c0211df96f021735251964981ac2b16bd90"
    sha256 cellar: :any,                 mojave:         "90f9b9b0ccadf93be027e515be356d0b92f4dfb33979f11df9fc7570c3249d0e"
    sha256 cellar: :any,                 high_sierra:    "f1242aaf566b272f69331d16441171b12d0b4cef8396b56e0a8246fe7618ca68"
    sha256 cellar: :any,                 sierra:         "0add799fff38395de6300f1b18102270bd269b5dc37714e7cac1873849b2ced7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673654f2eff65bcd6e03e420cd507b6b45ec5e8dd3419e86c78928b51fe05fe2"
  end

  depends_on "cmake" => :build

  def install
    # shapelib's CMake scripts interpret `CMAKE_INSTALL_LIBDIR=lib` as relative
    # to the current directory, i.e. `CMAKE_INSTALL_LIBDIR:PATH=$(pwd)/lib`
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_libdir: lib)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "shp_file", shell_output("#{bin}/shptreedump", 1)
  end
end
