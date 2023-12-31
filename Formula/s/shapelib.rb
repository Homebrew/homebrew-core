class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.6.0.tar.gz"
  sha256 "19528b24377241705637320c367943031ad5088665d1fb0e1eaa52a71264a6c4"
  license any_of: ["LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://download.osgeo.org/shapelib/"
    regex(/href=.*?shapelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5b0c88571a0eaa6eeefc6f37d629adbb02a718287c51ab9ec471684981b07083"
    sha256 cellar: :any,                 arm64_ventura:  "b90efa06081050c807e8a96deae77f0441e0614416c6ecf3560b4fc540a0a419"
    sha256 cellar: :any,                 arm64_monterey: "d9c38d3a68e182bb70a7b8bc4c61e9add34fcea08548ecd191ee85042551bdf3"
    sha256 cellar: :any,                 sonoma:         "580aa6a9fce667c5d9c23082cbe5627e7ad2d24f0f3eee6a410c80b8688dd137"
    sha256 cellar: :any,                 ventura:        "3a9f385280df8f4dd02492ca5cba775ae567c1700693f9a044c43d209b91b167"
    sha256 cellar: :any,                 monterey:       "426466c5396bb8a1cd4ebbe91e0685daf1ef084f74817194aa0b64f9d44b916e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2976aa3a0d58c936e57e265d26f49892470e4bab5f9cd8dcdf2e11ed003d7877"
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
