class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.21.4.tar.gz"
  sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "7ded9e75cd1ec90eff980ea4e6c0521b36589017bf0acb62217333e13587b6c1"
    sha256                               arm64_ventura:  "7a754f0c9a97663b06b2e6d4d1981466d9be5d53e05944907d45566374c501ef"
    sha256                               arm64_monterey: "90b2c03985689419a44adf25624956659fdbcb0a24fd270ec8d860ee6e270ec6"
    sha256                               sonoma:         "be3dd2bdc5e8f370e6ff645d79c388fc94297e79b8cedf7371efa85a56d0a989"
    sha256                               ventura:        "6ad77bc214708a2f7f75bf98196bf88f44ef4933a130a3d1604d91ec36e5e910"
    sha256                               monterey:       "35a17b327683a640aeda1b244500e24e97f06b0fd4670f2a8876c08d5cfc9bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f78d18274347eb17d660b304b9a5be507bf7c3b33f8388bdb9c08ad06c02bd91"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace reference to OpenCV's Cellar path
    opencv = Formula["opencv"]
    inreplace lib.glob("rtabmap-*/RTABMap_coreTargets.cmake"), opencv.prefix.realpath, opencv.opt_prefix
  end

  test do
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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.10)
      project(test)
      find_package(RTABMap REQUIRED COMPONENTS core)
      add_executable(test test.cpp)
      target_link_libraries(test rtabmap::core)
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <rtabmap/core/Rtabmap.h>
      #include <stdio.h>
      int main()
      {
        rtabmap::Rtabmap rtabmap;
        printf(RTABMAP_VERSION);
        return 0;
      }
    EOS
    args = std_cmake_args
    args << "-DCMAKE_BUILD_RPATH=#{lib}" if OS.linux?
    system "cmake", ".", *args, "-DCMAKE_VERBOSE_MAKEFILE=ON", "-DRTABMap_DIR=#{rtabmap_dir}"
    system "make"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
