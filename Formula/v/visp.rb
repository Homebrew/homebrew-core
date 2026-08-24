class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.7.0.tar.gz"
  sha256 "997f247f3702c83f0a8a6dc2f72ff98cfe3a5dcbd82f7c9f01d37ccd3b8ea97a"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c09318bafaf1457976fef31ac345ba04bf9cdb5582c22814f2523c8fe3d6a116"
    sha256 cellar: :any, arm64_sequoia: "48ed3b78a0fe23bc062c9fbd95aa61b34292f24b73356c8e0e58c45ce17c3f09"
    sha256 cellar: :any, arm64_sonoma:  "969ce097cb44eb6734fedcd62abc95298c0a19eccef5489b115e3dd875922901"
    sha256 cellar: :any, sonoma:        "83b28ac026bd1d5f9d566fa697df5ac099e540843fbf08075d4155dee6ab68f0"
    sha256 cellar: :any, arm64_linux:   "cb4083cc630ca975f2be25a58e57aaeb25a208f1c3a8f4d4d28aae34c2ecb56b"
    sha256 cellar: :any, x86_64_linux:  "19388ec4bdfbdd5d2d368dec03aa36d3c37ea823bc8a7e7cb052a774621dfae6"
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

  # Link OpenCV 5's relocated geometry/features modules.
  patch do
    url "https://github.com/lagadic/visp/commit/d57def89b50849ca191355a5d2f624e61f5d4e00.patch?full_index=1"
    sha256 "93b53b9d44f239bc92f448b212ff14d9301773ca6acfa78dee038c1398f8a207"
    type :backport
    resolves "https://github.com/lagadic/visp/pull/1975"
  end

  # Include OpenCV 5's relocated method headers.
  patch do
    url "https://github.com/lagadic/visp/commit/0c170eaeefcf5a49c631f8298997cddfd6f28fd7.patch?full_index=1"
    sha256 "ca0893a0af556127fd18d630847b606a348ee53d21d6173b2fe4621952eef6de"
    type :backport
    resolves "https://github.com/lagadic/visp/pull/1962"
  end

  def install
    ENV.cxx11

    # OpenCV 5.0.0 renamed the `3d` module to `geometry`.
    # PR ref: https://github.com/lagadic/visp/pull/1962
    inreplace %w[
      modules/core/include/visp3/core/vpMeterPixelConversion.h
      modules/core/include/visp3/core/vpPixelMeterConversion.h
      modules/core/src/camera/vpMeterPixelConversion.cpp
      modules/core/src/camera/vpPixelMeterConversion.cpp
      modules/vision/include/visp3/vision/vpKeyPoint.h
      modules/vision/src/key-point/vpKeyPoint.cpp
    ], "HAVE_OPENCV_3D", "HAVE_OPENCV_GEOMETRY"
    inreplace %w[
      modules/core/src/camera/vpMeterPixelConversion.cpp
      modules/core/src/camera/vpPixelMeterConversion.cpp
      modules/vision/src/key-point/vpKeyPoint.cpp
    ], "<opencv2/3d.hpp>", "<opencv2/geometry.hpp>"

    # Avoid superenv shim references
    inreplace "CMakeLists.txt" do |s|
      s.sub!(/CMake build tool:"\s+\${CMAKE_BUILD_TOOL}/,
             "CMake build tool:            gmake\"")
      s.sub!(/C\+\+ Compiler:"\s+\${VISP_COMPILER_STR}/,
             "C++ Compiler:                #{ENV.cxx}\"")
      s.sub!(/C Compiler:"\s+\${CMAKE_C_COMPILER}/,
             "C Compiler:                  #{ENV.cc}\"")
    end

    system "cmake", ".", "-DBUILD_APPS=OFF",
                         "-DBUILD_DEMOS=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF",
                         "-DBUILD_TUTORIALS=OFF",
                         "-DUSE_DC1394=ON",
                         "-DDC1394_INCLUDE_DIR=#{formula_opt_include("libdc1394")}",
                         "-DDC1394_LIBRARY=#{formula_opt_lib("libdc1394")/shared_library("libdc1394")}",
                         "-DUSE_EIGEN3=ON",
                         "-DEigen3_DIR=#{Formula["eigen"].opt_share}/eigen3/cmake",
                         "-DEIGEN3_INCLUDE_DIR=#{formula_opt_include("eigen")}/eigen3",
                         "-DUSE_GSL=ON",
                         "-DGSL_INCLUDE_DIR=#{formula_opt_include("gsl")}",
                         "-DGSL_cblas_LIBRARY=#{formula_opt_lib("gsl")/shared_library("libgslcblas")}",
                         "-DGSL_gsl_LIBRARY=#{formula_opt_lib("gsl")/shared_library("libgsl")}",
                         "-DUSE_JPEG=ON",
                         "-DJPEG_INCLUDE_DIR=#{formula_opt_include("jpeg-turbo")}",
                         "-DJPEG_LIBRARY=#{formula_opt_lib("jpeg-turbo")/shared_library("libjpeg")}",
                         "-DUSE_LAPACK=ON",
                         "-DUSE_LIBUSB_1=OFF",
                         "-DUSE_OPENCV=ON",
                         "-DOpenCV_DIR=#{Formula["opencv"].opt_share}/OpenCV",
                         "-DUSE_PCL=ON",
                         "-DUSE_PNG=ON",
                         "-DPNG_PNG_INCLUDE_DIR=#{formula_opt_include("libpng")}",
                         "-DPNG_LIBRARY_RELEASE=#{formula_opt_lib("libpng")/shared_library("libpng")}",
                         "-DUSE_PTHREAD=ON",
                         "-DUSE_PYLON=OFF",
                         "-DUSE_REALSENSE=OFF",
                         "-DUSE_REALSENSE2=OFF",
                         "-DUSE_X11=OFF",
                         "-DUSE_XML2=ON",
                         "-DUSE_ZBAR=ON",
                         "-DZBAR_INCLUDE_DIRS=#{formula_opt_include("zbar")}",
                         "-DZBAR_LIBRARIES=#{formula_opt_lib("zbar")/shared_library("libzbar")}",
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

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      sdk_path="$(xcrun --sdk macosx --show-sdk-path)"
      for file in "#{opt_lib}/cmake/visp/VISPConfig.cmake" \
                  "#{opt_lib}/cmake/visp/VISPModules.cmake" \
                  "#{opt_lib}/pkgconfig/visp.pc"; do
        sed -E -i.bak \
          's#/(Applications/Xcode[^[:space:];]*/SDKs|Library/Developer/CommandLineTools/SDKs)/MacOSX[^[:space:];]*\\.sdk#'"$sdk_path"'#g' \
          "$file"
        rm -f "$file.bak"
      done
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    on_macos do
      run "post-install", base: :libexec
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
