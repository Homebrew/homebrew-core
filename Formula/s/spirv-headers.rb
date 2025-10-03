class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  license "MIT"
  revision 1
  head "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "main"

  stable do
    url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/vulkan-sdk-1.4.321.0.tar.gz"
    sha256 "5bbea925663d4cd2bab23efad53874f2718248a73dcaf9dd21dff8cb48e602fc"

    # Backport SPV_INTEL_function_variants for SPIRV LLVM Translator >= 21
    patch do
      url "https://github.com/KhronosGroup/SPIRV-Headers/commit/9e3836d7d6023843a72ecd3fbf3f09b1b6747a9e.patch?full_index=1"
      sha256 "44eff041125f59dce93272be22226ab5e48fe4cf2397e422692d0c8679f40d51"
    end
  end

  livecheck do
    url :stable
    regex(/^(?:vulkan[._-])?sdk[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5fdb11bf7ec105db57352bd5bd8f2865ca8a45d0ca08ad336e82033c5258d52d"
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
