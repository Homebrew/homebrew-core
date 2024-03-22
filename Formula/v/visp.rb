class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.6.0.tar.gz"
  sha256 "eec93f56b89fd7c0d472b019e01c3fe03a09eda47f3903c38dc53a27cbfae532"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c02726d5cbbcb2d38e749543dde9266cc0f244ba2bb7804f585cd4335ebabf30"
    sha256 cellar: :any,                 arm64_ventura:  "e93d8fee821f74b705341d7c41429591d1a6428e63d6f940bceb499b5539d29e"
    sha256 cellar: :any,                 arm64_monterey: "654efbf9bdaae17214864c445bf887782e4e1297331440d4bfcccd9445b0aadb"
    sha256 cellar: :any,                 sonoma:         "3c53a6d696ee9f64ede2b906349e644bbd97ebdce006699b0f3dec74aec8800f"
    sha256 cellar: :any,                 ventura:        "cb321c2fbb7511012e4ef17516ab934fb51cb18b5fe394ffb835fd8061cf2f89"
    sha256 cellar: :any,                 monterey:       "edbc05ef6d2232f08a86976d0da59343c0349b03ad5fe6f24d8fd37ec8a7826a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66dc8d8da0015214136e788cc17507ffe0feebc1301ef5a0f22e9391d22b8e4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
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
    depends_on "libnsl"
  end

  fails_with gcc: "5"

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
    pkg_config_flags = shell_output("pkg-config --cflags --libs visp").chomp.split
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
