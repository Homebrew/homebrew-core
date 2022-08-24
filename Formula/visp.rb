class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.5.0.tar.gz"
  sha256 "494a648b2570da2a200ba326ed61a14e785eb9ee08ef12d3ad178b2f384d3d30"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "04c5346e20a6ae7138ba56355141b506ff8b55a74754c8752fc5b1a60cfbec57"
    sha256 cellar: :any,                 arm64_big_sur:  "be8755b39f4da98821c8491ca124f3dc57f03b03ef135c775ae007fce6299765"
    sha256 cellar: :any,                 monterey:       "5eb1116045f785c0930c8a0f328e0091475c43d7edbb4a815fc3f48a63dcf6c2"
    sha256 cellar: :any,                 big_sur:        "4a1235cb08ceeacee562df6f8cc1a925e613bcf5cd30ffc120230d7ca3cd2556"
    sha256 cellar: :any,                 catalina:       "78673ee15615a51c05c40684562c33218c4545e1e3a519f06f9defa10ce65eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6fc2864518d219de95042f4230f0c3786c14e7522d74c4f2ebb20ebf90cceb5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "zbar"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "libnsl"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    # Avoid superenv shim references
    inreplace "CMakeLists.txt" do |s|
      s.sub!(/CMake build tool:"\s+\${CMAKE_BUILD_TOOL}/,
             "CMake build tool:            gmake\"")
      s.sub!(/C\+\+ Compiler:"\s+\${VISP_COMPILER_STR}/,
             "C++ Compiler:                #{ENV.cxx}\"")
      s.sub!(/C Compiler:"\s+\${CMAKE_C_COMPILER}/,
             "C Compiler:                  #{ENV.cc}\"")
    end

    system "cmake", ".", "-DBUILD_DEMOS=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF",
                         "-DBUILD_TUTORIALS=OFF",
                         "-DUSE_DC1394=ON",
                         "-DDC1394_INCLUDE_DIR=#{Formula["libdc1394"].opt_include}",
                         "-DDC1394_LIBRARY=#{Formula["libdc1394"].opt_lib/shared_library("libdc1394")}",
                         "-DUSE_EIGEN3=ON",
                         "-DEigen3_DIR=#{Formula["eigen"].opt_share}/eigen3/cmake",
                         "-DUSE_GSL=ON",
                         "-DGSL_INCLUDE_DIR=#{Formula["gsl"].opt_include}",
                         "-DGSL_cblas_LIBRARY=#{Formula["gsl"].opt_lib/shared_library("libgslcblas")}",
                         "-DGSL_gsl_LIBRARY=#{Formula["gsl"].opt_lib/shared_library("libgsl")}",
                         "-DUSE_JPEG=ON",
                         "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}",
                         "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}",
                         "-DUSE_LAPACK=ON",
                         "-DUSE_LIBUSB_1=OFF",
                         "-DUSE_OPENCV=ON",
                         "-DOpenCV_DIR=#{Formula["opencv"].opt_share}/OpenCV",
                         "-DUSE_PCL=ON",
                         "-DUSE_PNG=ON",
                         "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
                         "-DPNG_LIBRARY_RELEASE=#{Formula["libpng"].opt_lib/shared_library("libpng")}",
                         "-DUSE_PTHREAD=ON",
                         "-DUSE_PYLON=OFF",
                         "-DUSE_REALSENSE=OFF",
                         "-DUSE_REALSENSE2=OFF",
                         "-DUSE_X11=OFF",
                         "-DUSE_XML2=ON",
                         "-DUSE_ZBAR=ON",
                         "-DZBAR_INCLUDE_DIRS=#{Formula["zbar"].opt_include}",
                         "-DZBAR_LIBRARIES=#{Formula["zbar"].opt_lib/shared_library("libzbar")}",
                         "-DUSE_ZLIB=ON",
                         *std_cmake_args

    # Replace generated references to OpenCV's Cellar path
    opencv = Formula["opencv"]
    opencv_references = Dir[
      "CMakeCache.txt",
      "CMakeFiles/Export/lib/cmake/visp/VISPModules.cmake",
      "VISPConfig.cmake",
      "VISPGenerateConfigScript.info.cmake",
      "VISPModules.cmake",
      "modules/**/flags.make",
      "unix-install/VISPConfig.cmake",
    ]
    inreplace opencv_references, opencv.prefix.realpath, opencv.opt_prefix
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    # Make sure software built against visp don't reference opencv's cellar path either
    inreplace lib/"pkgconfig/visp.pc", opencv.prefix.realpath, opencv.opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <visp3/core/vpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").chomp
  end
end
