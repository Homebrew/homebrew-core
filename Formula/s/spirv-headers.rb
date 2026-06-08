class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.350.0.tar.gz"
  sha256 "9905d9341f20388adb852c77dd982f2c4d539fd68e6c1f1bcebf034715f2d1d5"
  license "MIT"
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fa4aa34f7f755d197048122aad57d08d771345c731226403a0d707e1ba4fb0b"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example.cpp", testpath

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)

      add_library(SPIRV-Headers-example
                  ${CMAKE_CURRENT_SOURCE_DIR}/example.cpp)
      target_include_directories(SPIRV-Headers-example
                  PRIVATE ${SPIRV-Headers_SOURCE_DIR}/include)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end
