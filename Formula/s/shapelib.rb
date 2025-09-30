class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.6.2.tar.gz"
  sha256 "4b74a36ced94e9a7bea401157e664addcc5be251e7df7f88d4674361da012c21"
  license any_of: ["LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://download.osgeo.org/shapelib/"
    regex(/href=.*?shapelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43e91ffabf78719346ced0f39b03e619806a4df62f1c872cadfbc95c84effd45"
    sha256 cellar: :any,                 arm64_sequoia: "0489e4dc040f5fef2420fef08f1e016227edcda188b77097cf547275694a8cdc"
    sha256 cellar: :any,                 arm64_sonoma:  "a42ed3ca35bcacb6ec172188e5c48864b024dd0a9f4d190e1a4398626d2d3b8b"
    sha256 cellar: :any,                 sonoma:        "e7902a25697c5b22aeaa03c3719d00b420c7c91ee7fae2be217f9a33e9b9c0bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2897817454fdedab4d9c78ce7b521265aa16af4c89d2c614dacdf429a1eb143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c2e0458eafac06eae035aa3b82151a84c6a00bd3e1cdab4fc77d08ce7a47ab"
  end

  depends_on "cmake" => :build

  def install
    # shapelib's CMake scripts interpret `CMAKE_INSTALL_LIBDIR=lib` as relative
    # to the current directory, i.e. `CMAKE_INSTALL_LIBDIR:PATH=$(pwd)/lib`
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args(install_libdir: lib)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "shp_file", shell_output("#{bin}/shptreedump", 1)
  end
end
