class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.23.1.tar.gz"
  sha256 "8f0463d0b46418921da0503d5f991c7d0b8308b4926a069d9fe4ec811113502f"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_tahoe:   "7efb2a3f41186244c8525ada7fb5185ed7154db88dac97c60af42e9a3110a8fa"
    sha256                               arm64_sequoia: "5157e7c7894f777251fe28da97b7bb4e796be4218f05b9c831e9f120f82f246b"
    sha256                               arm64_sonoma:  "472adc41ae12088c4bd5cd04990ab420e1914223ac8e6048877375c62af261c3"
    sha256                               sonoma:        "1eca105d420d2774fda3ab1c295d43e8feaa170e99a4e18445091b219f22fb9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a6401a641b9642742a801de573c9467f41113f4be361466cabf8de5f7b1ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01f43f76842875f43875325774ee5c74cb77b60adc39478c9297221cb94bb8c"
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
