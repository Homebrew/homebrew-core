class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr/"
  url "https://visp-doc.inria.fr/download/releases/visp-3.4.0.tar.gz"
  sha256 "6c12bab1c1ae467c75f9e5831e01a1f8912ab7eae64249faf49d3a0b84334a77"
  license "GPL-2.0-or-later"
  revision 4

  livecheck do
    url "https://visp.inria.fr/download/"
    regex(/href=.*?visp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "02781fecb8b2e4b2a7e12b0b2d61f1868faf4b785e39ff79ad098d289394da76"
    sha256 cellar: :any, big_sur:       "f11e45987df927af5dc575e1ad49b7fb54fcebc1dee5f5f2015049d28abff0d7"
    sha256 cellar: :any, catalina:      "c66bdf7dc22c9c40639794ff928328b858a87941cf5c545ea109a253e33b73be"
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

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix Apple Silicon build
  patch :DATA

  def install
    ENV.cxx11

    # Avoid superenv shim references
    inreplace "CMakeLists.txt" do |s|
      s.sub!(/CMake build tool:"\s+\${CMAKE_BUILD_TOOL}/,
             "CMake build tool:            gmake\"")
      s.sub!(/C\+\+ Compiler:"\s+\${VISP_COMPILER_STR}/,
             "C++ Compiler:                clang++\"")
      s.sub!(/C Compiler:"\s+\${CMAKE_C_COMPILER}/,
             "C Compiler:                  clang\"")
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
                         "-DUSE_PYLON=OFF",
                         "-DUSE_REALSENSE=OFF",
                         "-DUSE_REALSENSE2=OFF",
                         "-DUSE_X11=OFF",
                         "-DUSE_XML2=ON",
                         "-DUSE_ZBAR=ON",
                         "-DZBAR_INCLUDE_DIRS=#{Formula["zbar"].opt_include}",
                         "-DZBAR_LIBRARIES=#{Formula["zbar"].opt_lib}/libzbar.dylib",
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
    system "make", "install"

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

__END__
diff --git a/3rdparty/simdlib/Simd/SimdEnable.h b/3rdparty/simdlib/Simd/SimdEnable.h
index a5ca71702..6c79eb0d9 100644
--- a/3rdparty/simdlib/Simd/SimdEnable.h
+++ b/3rdparty/simdlib/Simd/SimdEnable.h
@@ -44,8 +44,8 @@
 #include <TargetConditionals.h>             // To detect OSX or IOS using TARGET_OS_IPHONE or TARGET_OS_IOS macro
 #endif

-// The following includes <sys/auxv.h> and <asm/hwcap.h> are not available for iOS.
-#if (TARGET_OS_IOS == 0) // not iOS
+// The following includes <sys/auxv.h> and <asm/hwcap.h> are not available for macOS, iOS.
+#if !defined(__APPLE__) // not macOS, iOS
 #if defined(SIMD_PPC_ENABLE) || defined(SIMD_PPC64_ENABLE) || defined(SIMD_ARM_ENABLE) || defined(SIMD_ARM64_ENABLE)
 #include <unistd.h>
 #include <fcntl.h>
@@ -124,7 +124,7 @@ namespace Simd
     }
 #endif//defined(SIMD_X86_ENABLE) || defined(SIMD_X64_ENABLE)

-#if (TARGET_OS_IOS == 0) // not iOS
+#if !defined(__APPLE__) // not macOS, iOS
 #if defined(__GNUC__) && (defined(SIMD_PPC_ENABLE) || defined(SIMD_PPC64_ENABLE) || defined(SIMD_ARM_ENABLE) || defined(SIMD_ARM64_ENABLE))
     namespace CpuInfo
     {
