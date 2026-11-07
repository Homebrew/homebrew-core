class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.24.2.tar.gz"
  sha256 "96cca356c37d50609d7e1bc6379ce0ff3f66ecbd153583669bd0ba23b91ba969"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af0d41d1fdf50c62e10c342807be1db09107e5e4314582214ac81fbc9836d404"
    sha256 cellar: :any, arm64_tahoe:       "46c35686c663d8dd60fb5996555cbe1538048d1f383db1f39c1a55b1254406f0"
    sha256 cellar: :any, arm64_sequoia:     "e5fb69c572640e73ff8db09b9f38add435db9a190a81e256c47c48b99a45c7df"
    sha256 cellar: :any, arm64_linux:       "dd1b9b4d8753e93eb12a06c6fb3cf2e73f747105b50e9a5be53c996be95c0c68"
    sha256 cellar: :any, x86_64_linux:      "755d4de5a72fd886fbf8481ca74e78882dc8cd86b95d1c957b337db88f7d27de"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "sqlite"
  depends_on "vtk"

  on_macos do
    depends_on "boost"
    depends_on "flann"
    depends_on "freetype"
    depends_on "glew"
    depends_on "libfreenect"
    depends_on "libomp"
    depends_on "libpcap"
    depends_on "libpng"
    depends_on "lz4"
    depends_on "qhull"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Replace `Mat_` comma initializers, which OpenCV 5.1 removed
  patch do
    url "https://github.com/introlab/rtabmap/commit/606d29dfdaac80fde22e9a49120e011b4a2d8bf4.patch?full_index=1"
    sha256 "0443f61d3271b8f581d52f2b5dc058b519c3212661254c84f71bf2ba403c58b7"
    type :unofficial
    resolves "https://github.com/introlab/rtabmap/pull/1836"
  end

  def install
    # Use eigen's cmake configuration to support eigen 5.0.0
    rm "cmake_modules/FindEigen3.cmake"

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
