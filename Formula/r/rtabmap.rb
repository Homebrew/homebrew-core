class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.24.2.tar.gz"
  sha256 "96cca356c37d50609d7e1bc6379ce0ff3f66ecbd153583669bd0ba23b91ba969"
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
    manifest_sha256 "43b0f3f01940d10bc499e97ab1b3e3c91ef86df0b9c2bef9cac5555306532cf6"
    sha256 cellar: :any, arm64_golden_gate: "f486086a6f23edf9ac42208188239f4925a0c6a87e7b9128e00e5848e8c68f05"
    sha256 cellar: :any, arm64_tahoe:       "f72b37ca70e587e51b3bb2f28a1c0022218234d50cf4c19bec958a2ec532db84"
    sha256 cellar: :any, arm64_sequoia:     "24344b277457ffdf801ede110ef196bba7d003f0feb264fac68c8b51e5b7dcb6"
    sha256 cellar: :any, arm64_linux:       "84934033df7e5ce16de83473d03ef1056cdfd534428a5a64ecacc9d1728647d7"
    sha256 cellar: :any, x86_64_linux:      "a4b6460fe81712b2b0990668e2b856b138a0d11ef4ad7195d91f06486964078f"
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
    depends_on "libomp"
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

  deny_network_access!

  def install
    # Use eigen's cmake configuration to support eigen 5.0.0
    rm "cmake_modules/FindEigen3.cmake"

    # Toro license is CC-BY-NC-SA-3.0 which is DFSG-incompatible
    rm_r "corelib/src/optimizer/toro3d"
    args = %w[-DWITH_TORO=OFF]

    if OS.mac?
      args += %W[
        -DCMAKE_INSTALL_RPATH=#{rpath}
        -DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace reference to OpenCV's Cellar path
    opencv_prefix = formula_opt_prefix("opencv")
    inreplace lib.glob("rtabmap-*/RTABMap_coreTargets.cmake"), opencv_prefix.realpath, opencv_prefix

    return unless OS.mac?

    # Remove SDK include paths from CMake config files to avoid requiring specific SDK version
    sdk_path = MacOS.sdk_for_formula(self).path
    sdk_include_regex = Regexp.escape("#{sdk_path}/usr/include")
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
