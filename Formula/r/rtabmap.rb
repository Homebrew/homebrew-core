class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.23.8.tar.gz"
  sha256 "990029f1021e3c124c3accc7baf25b6c762c49537b9ae326965ff50b395afb11"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "6af2dd0708d261cabd2cdff67558cf8c632c165f8ebdc05235bb59a91a0c3cf3"
    sha256               arm64_sequoia: "7746776093a35f1fb73beebba31d5e313364de609420cf623d48c4975c980599"
    sha256               arm64_sonoma:  "f064255f50196f936fa95477d8e1b9f20d06f493b128914f7ebca4534cccdc47"
    sha256               sonoma:        "38e4569e7057bcdfd009581a4bec1ef0c630016b9a8d45c8852c1c0027fe0994"
    sha256 cellar: :any, arm64_linux:   "a4669d7444ee9e6a3c36452d7ab5508c35b328d438da2fa5e05584af6da916ed"
    sha256 cellar: :any, x86_64_linux:  "a2b65104f99801ddfb16fd1675a5e50612bb28bf9ce56dfdcdc247017d8040bf"
  end

  deprecate! date: "2026-10-09", because: :unsupported
  disable! date: "2027-07-09", because: :unsupported

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv@4"
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
    opencv = Formula["opencv@4"]
    inreplace lib.glob("rtabmap-*/RTABMap_coreTargets.cmake"), opencv.prefix.realpath, opencv.opt_prefix

    # opencv@4 is keg-only, so pin its CMake dir for RTABMapConfig consumers
    inreplace lib.glob("rtabmap-*/RTABMapConfig.cmake"),
              "find_dependency(OpenCV ",
              "set(OpenCV_DIR \"#{formula_opt_lib("opencv@4")}/cmake/opencv4\")\nfind_dependency(OpenCV "

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
