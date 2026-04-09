class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.6.3.tar.gz"
  sha256 "3ff5ead18ca6d2fe249f0e80b361e1ad6782165115268ed4a58c780a60c1e0eb"
  license any_of: ["LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://download.osgeo.org/shapelib/"
    regex(/href=.*?shapelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d270fad05338b3a2420a96a2b7e5b084a935e840e8deb0038369fffa7ef8586"
    sha256 cellar: :any,                 arm64_sequoia: "bac4ff987b17640f93f9e9d0ad0c7d046ba6ea780e8804f59a6ea2ebb63c13a8"
    sha256 cellar: :any,                 arm64_sonoma:  "d5ed7bbd8744d95d97f8d613fa5a4c2181477b02c087c5c104d4ea59a60f22c4"
    sha256 cellar: :any,                 sonoma:        "8301afafe682bc0ef1ad02da6a875a9f17e349c448145de7cab3af3bd306f3c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbe48e25f669a84512d7dde1882fabf63c287cb001041308cd3d1c130a2a64ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf7deccc48ed28fd9a051b66dd668737cb9842bf9bcf8d48766ddbf52e14722"
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
