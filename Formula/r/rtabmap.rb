class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  license "BSD-3-Clause"
  revision 10
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  stable do
    url "https://github.com/introlab/rtabmap/archive/refs/tags/0.21.4.tar.gz"
    sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"

    # Backport support for newer PCL
    # Ref: https://github.com/introlab/rtabmap/commit/cbd3995b600fc2acc4cb57b81f132288a6c91188
    patch :DATA
  end

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:  "1d433bee617217b945cc97f14e98ef947b3966d804f884f047607fb51fb13852"
    sha256                               arm64_ventura: "1e9747b0eb5689899563716f8956590a882545c2f0a9e73df82cd4148f1f198c"
    sha256                               sonoma:        "99d65d4e03958e697247bf67bbce34cd78356c48e06c119883252ab0eabc9f6f"
    sha256                               ventura:       "6d1567f28fac55c42410af8f0946efd7f5513a21c66bdce68a609f90918a47df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f9cf656952b8ca809bd8f68b6903727b9957aedb88f592e680de09ddbbbf37"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"
  depends_on "qt"
  depends_on "sqlite"
  depends_on "vtk"

  uses_from_macos "zlib"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "freetype"
    depends_on "glew"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "libpng"
    depends_on "lz4"
    depends_on "qhull"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace reference to OpenCV's Cellar path
    opencv = Formula["opencv"]
    inreplace lib.glob("rtabmap-*/RTABMap_coreTargets.cmake"), opencv.prefix.realpath, opencv.opt_prefix

    return unless OS.mac?

    # Remove SDK include paths from CMake config files to avoid requiring specific SDK version
    sdk_include_regex = Regexp.escape("#{MacOS.sdk_for_formula(self).path}/usr/include")
    inreplace lib.glob("rtabmap-*/RTABMap_{core,utilite}Targets.cmake"), /;#{sdk_include_regex}([;"])/, "\\1"
  end

  test do
    # Check all references to SDK path were removed from CMake config files
    prefix.glob("**/*.cmake") { |cmake| refute_match %r{/MacOSX[\d.]*\.sdk/}, cmake.read } if OS.mac?

    output = if OS.linux?
      # Linux CI cannot start windowed applications due to Qt plugin failures
      shell_output("#{bin}/rtabmap-console --version")
    else
      shell_output("#{bin}/rtabmap --version")
    end
    assert_match "RTAB-Map:               #{version}", output

    # Required to avoid missing Xcode headers
    # https://github.com/Homebrew/homebrew-core/pull/162576/files#r1489824628
    ENV.delete "CPATH" if OS.mac? && MacOS::CLT.installed?

    rtabmap_dir = lib/"rtabmap-#{version.major_minor}"
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test)
      find_package(RTABMap REQUIRED COMPONENTS core)
      add_executable(test test.cpp)
      target_link_libraries(test rtabmap::core)
    CMAKE
    (testpath/"test.cpp").write <<~CPP
      #include <rtabmap/core/Rtabmap.h>
      #include <stdio.h>
      int main()
      {
        rtabmap::Rtabmap rtabmap;
        printf(RTABMAP_VERSION);
        return 0;
      }
    CPP

    args = std_cmake_args
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DRTABMap_DIR=#{rtabmap_dir}"
    system "cmake", "--build", "build"
    assert_equal version.to_s, shell_output("./build/test").strip
  end
end

__END__
diff --git a/corelib/src/CameraThread.cpp b/corelib/src/CameraThread.cpp
index a18fc2c1..d1486b20 100644
--- a/corelib/src/CameraThread.cpp
+++ b/corelib/src/CameraThread.cpp
@@ -44,7 +44,7 @@ SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 #include <rtabmap/utilite/ULogger.h>
 #include <rtabmap/utilite/UStl.h>
 
-#include <pcl/io/io.h>
+#include <pcl/common/io.h>
 
 namespace rtabmap
 {
