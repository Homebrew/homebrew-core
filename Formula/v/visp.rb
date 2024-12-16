class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.6.0.tar.gz"
  sha256 "eec93f56b89fd7c0d472b019e01c3fe03a09eda47f3903c38dc53a27cbfae532"
  license "GPL-2.0-or-later"
  revision 9

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "af4c89b76780c58e894a873e8d42d4885b567e01d6f86bec09de95c517c3ebfc"
    sha256 cellar: :any,                 arm64_ventura: "52e8b99511e305944e322a477f839926e09aea706966ed8c293155166059df4b"
    sha256 cellar: :any,                 sonoma:        "1c55447d8f7aa637697e6a7074d5e5fae90099f02ae447eba53cb7965ab17614"
    sha256 cellar: :any,                 ventura:       "be848c02ccf208389f5ea1104bfe3a25d33bd713604b7e2ff2f64649bc2a9f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "006043deaa30823969980eff82a6d1280816da78d5f8e29bee182a1f70acddd6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "vtk"
  depends_on "zbar"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "glew"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "qhull"
    depends_on "qt"
  end

  on_linux do
    depends_on "libnsl"
  end

  # Backport fix for recent Apple Clang
  patch do
    url "https://github.com/lagadic/visp/commit/8c1461661f99a5db31c89ede9946d2b0244f8123.patch?full_index=1"
    sha256 "1e0126c731bf14dfe915088a4205a16ec0b6d5f2ea57d0e84f2f69b8e86b144f"
  end
  patch do
    url "https://github.com/lagadic/visp/commit/e41aa4881e0d58c182f0c140cc003b37afb99d39.patch?full_index=1"
    sha256 "c0dd6678f1b39473da885f7519daf16018e20209c66cdd04f660a968f6fadbba"
  end

  # One usage of OpenCV Universal Intrinsics API altered starting from 4.9.0
  # Remove this patch if it's merged into a future version
  # https://github.com/lagadic/visp/issues/1309
  # Patch source: https://github.com/lagadic/visp/pull/1310
  patch :DATA

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
    inreplace [lib/"pkgconfig/visp.pc", lib/"cmake/visp/VISPConfig.cmake", lib/"cmake/visp/VISPModules.cmake"],
              opencv.prefix.realpath, opencv.opt_prefix
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
  end
end

__END__
diff --git a/modules/tracker/mbt/src/depth/vpMbtFaceDepthDense.cpp b/modules/tracker/mbt/src/depth/vpMbtFaceDepthDense.cpp
index 8a47b5d437..c6d636bc9e 100644
--- a/modules/tracker/mbt/src/depth/vpMbtFaceDepthDense.cpp
+++ b/modules/tracker/mbt/src/depth/vpMbtFaceDepthDense.cpp
@@ -606,9 +606,15 @@ void vpMbtFaceDepthDense::computeInteractionMatrixAndResidu(const vpHomogeneousM
         cv::v_float64x2 vx, vy, vz;
         cv::v_load_deinterleave(ptr_point_cloud, vx, vy, vz);
 
+#if (VISP_HAVE_OPENCV_VERSION >= 0x040900)
+        cv::v_float64x2 va1 = cv::v_sub(cv::v_mul(vnz, vy), cv::v_mul(vny, vz)); // vnz*vy - vny*vz
+        cv::v_float64x2 va2 = cv::v_sub(cv::v_mul(vnx, vz), cv::v_mul(vnz, vx)); // vnx*vz - vnz*vx
+        cv::v_float64x2 va3 = cv::v_sub(cv::v_mul(vny, vx), cv::v_mul(vnx, vy)); // vny*vx - vnx*vy
+#else
         cv::v_float64x2 va1 = vnz*vy - vny*vz;
         cv::v_float64x2 va2 = vnx*vz - vnz*vx;
         cv::v_float64x2 va3 = vny*vx - vnx*vy;
+#endif
 
         cv::v_float64x2 vnxy = cv::v_combine_low(vnx, vny);
         cv::v_store(ptr_L, vnxy);
@@ -630,7 +636,12 @@ void vpMbtFaceDepthDense::computeInteractionMatrixAndResidu(const vpHomogeneousM
         cv::v_store(ptr_L, vnxy);
         ptr_L += 2;
 
+#if (VISP_HAVE_OPENCV_VERSION >= 0x040900)
+        cv::v_float64x2 verr = cv::v_add(vd, cv::v_muladd(vnx, vx, cv::v_muladd(vny, vy, cv::v_mul(vnz, vz))));
+#else
         cv::v_float64x2 verr = vd + cv::v_muladd(vnx, vx, cv::v_muladd(vny, vy, vnz*vz));
+#endif
+
         cv::v_store(ptr_error, verr);
         ptr_error += 2;
 #elif USE_SSE
