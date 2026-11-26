class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.24.2.tar.gz"
  sha256 "96cca356c37d50609d7e1bc6379ce0ff3f66ecbd153583669bd0ba23b91ba969"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  # Upstream doesn't create releases for all tagged versions, so we use the
  # `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    manifest_sha256 "11d0a2674f4f3cb72a072dd1d7eb6681ae2c57618e5e377e26c54d30929e7586"
    sha256 cellar: :any, arm64_golden_gate: "f773dd3ab09c09ca6e7011f9cd67d595c503de7a9a78f42a10b26ef657e1b4f5"
    sha256 cellar: :any, arm64_tahoe:       "1b2c5df7ed307024da0444fd597ee9d0861b1444db0974047b626dfba721cff3"
    sha256 cellar: :any, arm64_sequoia:     "049c72f18c35dc7a1cd60dd21148607063967db5958757a3283787307132c69c"
    sha256 cellar: :any, arm64_linux:       "57e44009397643347f3814af4a1157f10d73c26d4fbc1165ed22342820861f12"
    sha256 cellar: :any, x86_64_linux:      "fad7f2e32803a15daec98b2961f37ac8afab823a428f047f33a3eaf103ae85fc"
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
