class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.1.0.tar.gz"
  sha256 "2a1df8195b06f9a057bd4c7d987697be2fdcc9d169e8d550fcf68e5d7f129d96"
  revision 2

  bottle do
    sha256 "ed11d41df8e68b67795cdde1cc9dc2761bd66b6cb406e0cbc955db90ff066a9e" => :mojave
    sha256 "a2b5b96e25a69762a1a6d07ab66bf9790adc9fc436a5a57c29d82f9ca13c426f" => :high_sierra
    sha256 "b157bf06ff32d11195abafc2e82b7277e08b76bddeff95690f7a7277735ca118" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "opencv"
  depends_on "zbar"

  # Allow compilation with OpenCV 4, remove in next version
  # https://github.com/lagadic/visp/issues/373
  # https://github.com/lagadic/visp/commit/547041b8
  patch :DATA

  needs :cxx11

  def install
    ENV.cxx11

    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    system "cmake", ".", "-DBUILD_DEMOS=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_TESTS=OFF",
                         "-DBUILD_TUTORIALS=OFF",
                         "-DUSE_DC1394=ON",
                         "-DDC1394_INCLUDE_DIR=#{Formula["libdc1394"].opt_include}",
                         "-DDC1394_LIBRARY=#{Formula["libdc1394"].opt_lib}/libdc1394.dylib",
                         "-DUSE_EIGEN3=ON",
                         "-DEigen3_DIR=#{Formula["eigen"].opt_share}/eigen3/cmake",
                         "-DUSE_GSL=ON",
                         "-DGSL_INCLUDE_DIR=#{Formula["gsl"].opt_include}",
                         "-DGSL_cblas_LIBRARY=#{Formula["gsl"].opt_lib}/libgslcblas.dylib",
                         "-DGSL_gsl_LIBRARY=#{Formula["gsl"].opt_lib}/libgsl.dylib",
                         "-DUSE_JPEG=ON",
                         "-DJPEG_INCLUDE_DIR=#{Formula["jpeg"].opt_include}",
                         "-DJPEG_LIBRARY=#{Formula["jpeg"].opt_lib}/libjpeg.dylib",
                         "-DUSE_LAPACK=OFF",
                         "-DUSE_LIBUSB_1=OFF",
                         "-DUSE_OPENCV=ON",
                         "-DOpenCV_DIR=#{Formula["opencv"].opt_share}/OpenCV",
                         "-DUSE_PCL=OFF",
                         "-DUSE_PNG=ON",
                         "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}",
                         "-DPNG_LIBRARY_RELEASE=#{Formula["libpng"].opt_lib}/libpng.dylib",
                         "-DUSE_PTHREAD=ON",
                         "-DPTHREAD_INCLUDE_DIR=#{sdk}/usr/include",
                         "-DPTHREAD_LIBRARY=/usr/lib/libpthread.dylib",
                         "-DUSE_PYLON=OFF",
                         "-DUSE_REALSENSE=OFF",
                         "-DUSE_REALSENSE2=OFF",
                         "-DUSE_X11=OFF",
                         "-DUSE_XML2=ON",
                         "-DXML2_INCLUDE_DIR=#{sdk}/usr/include/libxml2",
                         "-DXML2_LIBRARY=/usr/lib/libxml2.dylib",
                         "-DUSE_ZBAR=ON",
                         "-DZBAR_INCLUDE_DIRS=#{Formula["zbar"].opt_include}",
                         "-DZBAR_LIBRARIES=#{Formula["zbar"].opt_lib}/libzbar.dylib",
                         "-DUSE_ZLIB=ON",
                         "-DZLIB_INCLUDE_DIR=#{sdk}/usr/include",
                         "-DZLIB_LIBRARY_RELEASE=/usr/lib/libz.dylib",
                         "-DWITH_LAPACK=OFF",
                         *std_cmake_args
    system "make", "install"
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

__END__
diff --git a/modules/core/include/visp3/core/vpImageConvert.h b/modules/core/include/visp3/core/vpImageConvert.h
index 65165748a9f6c2b2145d57247c4575dbfe96ef97..54d32b12e50d935b29656a2735d907e8212005d0 100644
--- a/modules/core/include/visp3/core/vpImageConvert.h
+++ b/modules/core/include/visp3/core/vpImageConvert.h
@@ -56,21 +56,26 @@
 #include <visp3/core/vpRGBa.h>

 #ifdef VISP_HAVE_OPENCV
-#if (VISP_HAVE_OPENCV_VERSION >= 0x030000) // Require opencv >= 3.0.0
-#include <opencv2/core/core.hpp>
-#include <opencv2/highgui/highgui.hpp>
-#include <opencv2/imgproc/imgproc.hpp>
+#if (VISP_HAVE_OPENCV_VERSION >= 0x040000) // Require opencv >= 4.0.0
+#  include <opencv2/imgproc/types_c.h>
+#  include <opencv2/imgproc.hpp>
+#  include <opencv2/imgcodecs.hpp>
+#  include <opencv2/highgui.hpp>
+#elif (VISP_HAVE_OPENCV_VERSION >= 0x030000) // Require opencv >= 3.0.0
+#  include <opencv2/core/core.hpp>
+#  include <opencv2/highgui/highgui.hpp>
+#  include <opencv2/imgproc/imgproc.hpp>
 #elif (VISP_HAVE_OPENCV_VERSION >= 0x020408) // Require opencv >= 2.4.8
-#include <opencv2/core/core.hpp>
-#include <opencv2/highgui/highgui.hpp>
-#include <opencv2/imgproc/imgproc.hpp>
+#  include <opencv2/core/core.hpp>
+#  include <opencv2/highgui/highgui.hpp>
+#  include <opencv2/imgproc/imgproc.hpp>
 #elif (VISP_HAVE_OPENCV_VERSION >= 0x020101) // Require opencv >= 2.1.1
-#include <opencv2/core/core.hpp>
-#include <opencv2/highgui/highgui.hpp>
-#include <opencv2/highgui/highgui_c.h>
-#include <opencv2/legacy/legacy.hpp>
+#  include <opencv2/core/core.hpp>
+#  include <opencv2/highgui/highgui.hpp>
+#  include <opencv2/highgui/highgui_c.h>
+#  include <opencv2/legacy/legacy.hpp>
 #else
-#include <highgui.h>
+#  include <highgui.h>
 #endif
 #endif

diff --git a/modules/vision/include/visp3/vision/vpKeyPoint.h b/modules/vision/include/visp3/vision/vpKeyPoint.h
index d269d22a0c4b2549b6df8f3cbccc8005651a4784..468241311eb87e8b12b8c261c39fc46396a0d549 100644
--- a/modules/vision/include/visp3/vision/vpKeyPoint.h
+++ b/modules/vision/include/visp3/vision/vpKeyPoint.h
@@ -57,7 +57,7 @@
 #include <visp3/vision/vpBasicKeyPoint.h>
 #include <visp3/vision/vpPose.h>
 #ifdef VISP_HAVE_MODULE_IO
-#include <visp3/io/vpImageIo.h>
+#  include <visp3/io/vpImageIo.h>
 #endif
 #include <visp3/core/vpConvert.h>
 #include <visp3/core/vpCylinder.h>
@@ -68,20 +68,25 @@
 // Require at least OpenCV >= 2.1.1
 #if (VISP_HAVE_OPENCV_VERSION >= 0x020101)

-#include <opencv2/calib3d/calib3d.hpp>
-#include <opencv2/features2d/features2d.hpp>
-#include <opencv2/imgproc/imgproc.hpp>
-
-#if defined(VISP_HAVE_OPENCV_XFEATURES2D) // OpenCV >= 3.0.0
-#include <opencv2/xfeatures2d.hpp>
-#elif defined(VISP_HAVE_OPENCV_NONFREE) && (VISP_HAVE_OPENCV_VERSION >= 0x020400) &&                                   \
-    (VISP_HAVE_OPENCV_VERSION < 0x030000)
-#include <opencv2/nonfree/nonfree.hpp>
-#endif
-
-#ifdef VISP_HAVE_XML2
-#include <libxml/xmlwriter.h>
-#endif
+#  include <opencv2/calib3d/calib3d.hpp>
+#  include <opencv2/features2d/features2d.hpp>
+#  include <opencv2/imgproc/imgproc.hpp>
+
+#  if (VISP_HAVE_OPENCV_VERSION >= 0x040000) // Require opencv >= 4.0.0
+#    include <opencv2/imgproc/imgproc_c.h>
+#    include <opencv2/imgproc.hpp>
+#  endif
+
+#  if defined(VISP_HAVE_OPENCV_XFEATURES2D) // OpenCV >= 3.0.0
+#    include <opencv2/xfeatures2d.hpp>
+#  elif defined(VISP_HAVE_OPENCV_NONFREE) && (VISP_HAVE_OPENCV_VERSION >= 0x020400) && \
+     (VISP_HAVE_OPENCV_VERSION < 0x030000)
+#    include <opencv2/nonfree/nonfree.hpp>
+#  endif
+
+#  ifdef VISP_HAVE_XML2
+#    include <libxml/xmlwriter.h>
+#  endif

 /*!
   \class vpKeyPoint
