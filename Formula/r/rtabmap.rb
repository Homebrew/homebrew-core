class Rtabmap < Formula
  desc "Visual and LiDAR SLAM library and standalone application"
  homepage "https://introlab.github.io/rtabmap"
  url "https://github.com/introlab/rtabmap/archive/refs/tags/0.21.4.tar.gz"
  sha256 "242f8da7c5d20f86a0399d6cfdd1a755e64e9117a9fa250ed591c12f38209157"
  license "BSD-3-Clause"
  head "https://github.com/introlab/rtabmap.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "2c38fca1ac84b47eba43de32a781d2fd181a263f4925ef15fa280c84efe9a3fa"
    sha256                               arm64_ventura:  "396c70a3efbdd53ae2605906f2eaedcfb9335ca9082ada6e5691d2aa4c5bf66f"
    sha256                               arm64_monterey: "86d6a2567d2e28c55f48232a186fa167758bff7772b2294b760ec362a2b81f87"
    sha256                               sonoma:         "be8665e9d7ae0b1effcfef0c4f82ae86e665ba25dad6016fd37aab5c71800bc7"
    sha256                               ventura:        "d262fc25ce3f5c1c251b38976317eb969b83caa73a8fb36ab9dc6d7ef6aa1c72"
    sha256                               monterey:       "3352cfbbda1039bceecaf60d83cafff009f58c6afb3fec80600194cf9c3f62d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab72221ba2f0dff302f8999f4d5f32c67c4ed79b62f9c3b7fe3fd6ad7ac7d4c6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "g2o"
  depends_on "librealsense"
  depends_on "octomap"
  depends_on "opencv"
  depends_on "pcl"
  depends_on "pdal"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
