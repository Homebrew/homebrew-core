class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.7.0.tar.gz"
  sha256 "997f247f3702c83f0a8a6dc2f72ff98cfe3a5dcbd82f7c9f01d37ccd3b8ea97a"
  license "GPL-2.0-or-later"
  revision 6

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c3b0272ffd83f11a560601fd14924dbe58eadb878bee8a6723b5acf1c2aff3a"
    sha256 cellar: :any,                 arm64_sequoia: "af7afae0c8fa6d9350a64822b503463bbdd5c5b0e0c4ffe58f7ca279a89abc5d"
    sha256 cellar: :any,                 arm64_sonoma:  "d2146363c3b90fc2e88222cf696b75ac01e4f89071f05a2389cba47943abeeb1"
    sha256 cellar: :any,                 sonoma:        "d0373498e190ed33687f84445b60732e786f4d86ee26fa3b203ee00e5a5fc42a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36c34de1969e7845837fdd8fdcdf54cef44e4854d289c141fbeb6fe81d1f1cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3bd1219cf9091aed005f4656bcffd3de7c5fe86b622f48e84213a2e25e56182"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]

  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "lz4"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "vtk"
  depends_on "zbar"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "glew"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "qhull"
    depends_on "qtbase"
  end

  on_linux do
    depends_on "libnsl"
    depends_on "zlib-ng-compat"
  end

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
                         "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
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
                         "-DUSE_MAVSDK=OFF",
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
    inreplace [lib/"pkgconfig/visp.pc", lib/"cmake/visp/VISPConfig.cmake"],
              opencv.prefix.realpath, opencv.opt_prefix
  end

  def post_install
    # Replace SDK paths in bottle when pouring on different OS version than bottle OS.
    # This avoids error like https://github.com/orgs/Homebrew/discussions/5853
    # TODO: Consider handling this in brew, e.g. as part of keg cleaner or bottle relocation
    if OS.mac? && (tab = Tab.for_formula(self)).poured_from_bottle
      bottle_os = bottle&.tag&.to_macos_version
      if bottle_os.nil? && (os_version = tab.built_on.fetch("os_version", "")[/\d+(?:\.\d+)*$/])
        bottle_os = MacOSVersion.new(os_version).strip_patch
      end
      return if bottle_os.nil? || MacOS.version == bottle_os

      sdk_path_files = [
        lib/"cmake/visp/VISPConfig.cmake",
        lib/"cmake/visp/VISPModules.cmake",
        lib/"pkgconfig/visp.pc",
      ]
      bottle_sdk_path = MacOS.sdk_for_formula(self, bottle_os).path
      inreplace sdk_path_files, bottle_sdk_path, MacOS.sdk_for_formula(self).path, audit_result: false
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <visp3/core/vpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    CPP
    pkg_config_flags = shell_output("pkgconf --cflags --libs visp").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *pkg_config_flags
    assert_equal version.to_s, shell_output("./test").chomp

    ENV.delete "CPATH"
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
      project(visp-check)
      find_package(VISP REQUIRED)
      include_directories(${VISP_INCLUDE_DIRS})
      add_executable(visp-check test.cpp)
      target_link_libraries(visp-check ${VISP_LIBRARIES})
    CMAKE

    system "cmake", "-B", "build", "-S", "."
    system "cmake", "--build", "build"
    assert_equal version.to_s, shell_output("build/visp-check").chomp
  end
end
