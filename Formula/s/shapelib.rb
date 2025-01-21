class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.6.1.tar.gz"
  sha256 "5da90a60e25440f108f4e8e95732bfa83ede13c8e0c2bcf80ae41006cc8ebc20"
  license any_of: ["LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://download.osgeo.org/shapelib/"
    regex(/href=.*?shapelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "fb49cfcd0596b179c7b2a0e8b455b846db356aa2166919cf811507768d7065cf"
    sha256 cellar: :any,                 arm64_sonoma:   "3b896b17d9691d399ea9f0d7350eef3c43b4c03b0616e2dc5bb4f17060e51b3a"
    sha256 cellar: :any,                 arm64_ventura:  "b3cc3ed80a625c61930c2ae5f8629556fe9b34a2b36568c6c887b3e0de3a561f"
    sha256 cellar: :any,                 arm64_monterey: "cefd09ed4bc3d75842d93c83d30a3746a145e80c19f0ff736f52fae534b8d6ac"
    sha256 cellar: :any,                 sonoma:         "fcd168887712a91344618537d20c0579ff2907b9d887017b07aca2b921526306"
    sha256 cellar: :any,                 ventura:        "87e9ad2a1b66cb3c589db6f95f83ba7605363e8441a1f64b7453d99f8511fe2c"
    sha256 cellar: :any,                 monterey:       "f4ccafad07023f98b85e7477224151f098a792404c52e84d2c5150998cd1e020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10c1872d151e320089896c49d5234ba25355d660d0e4b440a1e1ea989f99c8f3"
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
