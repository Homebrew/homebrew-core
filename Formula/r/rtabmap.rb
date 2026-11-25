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
    manifest_sha256 "8241c96ad2d8d0bb13f54d22870af06968e3f60a2bb41bd9836b17bb65d496e1"
    sha256 cellar: :any, arm64_golden_gate: "d639196fce1643dfb8723e30a87cb2ad947579eb22c74bfffcf6553bef72e53a"
    sha256 cellar: :any, arm64_tahoe:       "48cc0dc523b4dd9cec50a902d22f2933d9630e5a2491a0a0ff667985e26dabc6"
    sha256 cellar: :any, arm64_sequoia:     "0219956bfd7466ffca7ef0c03161d1a7e3bfcaa138055c0870df9d764870ac22"
    sha256 cellar: :any, arm64_linux:       "dfc94d2b259de3a32dedda80ae2e4e12ed618185b19386c940a18f3965348007"
    sha256 cellar: :any, x86_64_linux:      "5f4ab3de67b3d7967f8ce2bff7c639c88b4e51df9fa0d25f4b5108318fa42336"
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
