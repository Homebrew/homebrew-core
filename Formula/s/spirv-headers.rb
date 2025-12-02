class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.328.1.tar.gz"
  sha256 "602364ab7bf404a7f352df7da5c645f1c4558a9c92616f8ee33422b04d5e35b7"
  license "MIT"
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "531c9e9d17a3e4dcaf870a9de694d68ba3098c7c6643ba5ba6f56c57b8868e0d"
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
