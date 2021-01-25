class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.3.0.tar.gz"
  sha256 "f2ed11f8fee52c89487e6e24ba6a31fa604b326e08fb0f561a22c877ebdb640d"
  revision 11

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "bbc1c7b0022d1c99d9d144f73a82024d6af8eee0763a794fbc5ce0da98ac6308" => :catalina
    sha256 "a6c1d3468de47a6725bea5933e1fddbb616fb5736af372a158a1d10aba992101" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "gsl"
  depends_on "jpeg"
  depends_on "libdc1394"
  depends_on "libpng"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "zbar"

  # from first commit at https://github.com/lagadic/visp/pull/768 - remove in next release
  patch do
    url "https://github.com/lagadic/visp/commit/61c8beb8442f9e0fe7df8966e2e874929af02344.patch?full_index=1"
    sha256 "429bf02498fc03fff7bc2a2ad065dea6d8a8bfbde6bb1adb516fa821b1e5c96f"
  end

  # Fixes build on OpenCV >= 4.4.0
  # Extracted from https://github.com/lagadic/visp/pull/795
  patch :DATA

  def install
    ENV.cxx11

    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    # Avoid superenv shim references
    inreplace "CMakeLists.txt" do |s|
      s.sub! /CMake build tool:"\s+\${CMAKE_BUILD_TOOL}/,
             "CMake build tool:            gmake\""
      s.sub! /C\+\+ Compiler:"\s+\${VISP_COMPILER_STR}/,
             "C++ Compiler:                clang++\""
      s.sub! /C Compiler:"\s+\${CMAKE_C_COMPILER}/,
             "C Compiler:                  clang\""
    end

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
                         "-DUSE_LAPACK=ON",
                         "-DUSE_LIBUSB_1=OFF",
                         "-DUSE_OPENCV=ON",
                         "-DOpenCV_DIR=#{Formula["opencv"].opt_share}/OpenCV",
                         "-DUSE_PCL=ON",
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
diff --git a/modules/vision/src/key-point/vpKeyPoint.cpp b/modules/vision/src/key-point/vpKeyPoint.cpp
index dd5cabf..23ed382 100644
--- a/modules/vision/src/key-point/vpKeyPoint.cpp
+++ b/modules/vision/src/key-point/vpKeyPoint.cpp
@@ -2269,7 +2269,7 @@ void vpKeyPoint::initDetector(const std::string &detectorName)

   if (detectorNameTmp == "SIFT") {
 #ifdef VISP_HAVE_OPENCV_XFEATURES2D
-    cv::Ptr<cv::FeatureDetector> siftDetector = cv::xfeatures2d::SIFT::create();
+    cv::Ptr<cv::FeatureDetector> siftDetector = cv::SIFT::create();
     if (!usePyramid) {
       m_detectors[detectorNameTmp] = siftDetector;
     } else {
@@ -2447,7 +2447,7 @@ void vpKeyPoint::initExtractor(const std::string &extractorName)
 #else
   if (extractorName == "SIFT") {
 #ifdef VISP_HAVE_OPENCV_XFEATURES2D
-    m_extractors[extractorName] = cv::xfeatures2d::SIFT::create();
+    m_extractors[extractorName] = cv::SIFT::create();
 #else
     std::stringstream ss_msg;
     ss_msg << "Fail to initialize the extractor: SIFT. OpenCV version  " << std::hex << VISP_HAVE_OPENCV_VERSION
