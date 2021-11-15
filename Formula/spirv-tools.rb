class SpirvTools < Formula
  desc "API and commands for processing SPIR-V modules"
  homepage "https://github.com/KhronosGroup/SPIRV-Tools"
  url "https://github.com/KhronosGroup/SPIRV-Tools/archive/v2021.4.tar.gz"
  sha256 "d68de260708dda785d109ff1ceeecde2d2ab71142fa5bf59061bb9f47dd3bb2c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4d6a8fca257d7de1d78168e2dcb1f49056ffbd388c59114ed37ae464b9f085b"
    sha256 cellar: :any,                 arm64_big_sur:  "a24e7ffaa9c6d57c00b0c8cc93052f07eaa42c0f25b037a4f920109d25d3aab1"
    sha256 cellar: :any,                 monterey:       "0d4a0adf1357d733f663de0ea622252229b5548e600d6eef590c0f9be7418a4a"
    sha256 cellar: :any,                 big_sur:        "92b58c54632a083e1dbbe49525e5372015241a65813817e5446b3388fb90b756"
    sha256 cellar: :any,                 catalina:       "f8c766313e53cd3fdd059ddcdedc88807dd87a2a8dbbb895d061edd4512dfb6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f193bfb2d43bdb75c047431c5c3e605d2526c8121d4e35bd48e01037a57a4e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  resource "re2" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/re2.git",
        revision: "4244cd1cb492fa1d10986ec67f862964c073f844"
  end

  resource "effcee" do
    # revision number could be found in ./DEPS
    url "https://github.com/google/effcee.git",
        revision: "ddf5e2bb92957dc8a12c5392f8495333d6844133"
  end

  resource "spirv-headers" do
    # revision number could be found in ./DEPS
    url "https://github.com/KhronosGroup/SPIRV-Headers.git",
        revision: "814e728b30ddd0f4509233099a3ad96fd4318c07"
  end

  def install
    (buildpath/"external/re2").install resource("re2")
    (buildpath/"external/effcee").install resource("effcee")
    (buildpath/"external/SPIRV-Headers").install resource("spirv-headers")

    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBUILD_SHARED_LIBS=ON",
                            "-DSPIRV_SKIP_TESTS=ON",
                            "-DSPIRV_TOOLS_BUILD_STATIC=OFF"
      system "make", "install"
    end

    (libexec/"examples").install "examples/cpp-interface/main.cpp"
  end

  test do
    cp libexec/"examples"/"main.cpp", "test.cpp"

    args = "-lc++"

    on_linux do
      args = ["-lstdc++", "-lm"]
    end

    system ENV.cc, "-o", "test", "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                   "-lSPIRV-Tools", "-lSPIRV-Tools-link", "-lSPIRV-Tools-opt", *args
    system "./test"
  end
end
