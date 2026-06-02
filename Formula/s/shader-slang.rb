class ShaderSlang < Formula
  desc "Shading language that compiles to HLSL, GLSL, SPIR-V, MSL, WGSL, CUDA, and CPU"
  homepage "https://shader-slang.org/"
  # Use the Git URL so external/ submodules are fetched and `git describe`
  # populates SLANG_VERSION (see cmake/GitVersion.cmake).
  url "https://github.com/shader-slang/slang.git",
      tag:      "v2026.10.2",
      revision: "2129fc6cf0fea8e40ee23d71064c6c1a8a22e2ae"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/shader-slang/slang.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"

  def install
    # slang-glslang.cpp uses the in-tree layout `#include "SPIRV/..."`, but
    # glslang installs those headers under include/glslang/SPIRV/.
    ENV.append "CXXFLAGS", "-I#{Formula["glslang"].opt_include}/glslang"

    args = %W[
      -G Ninja
      -DSLANG_LIB_TYPE=SHARED
      -DSLANG_ENABLE_GFX=OFF
      -DSLANG_ENABLE_SLANG_RHI=OFF
      -DSLANG_ENABLE_TESTS=OFF
      -DSLANG_ENABLE_EXAMPLES=OFF
      -DSLANG_ENABLE_REPLAYER=OFF
      -DSLANG_ENABLE_DXIL=OFF
      -DSLANG_EXCLUDE_DAWN=ON
      -DSLANG_EXCLUDE_TINT=ON
      -DSLANG_SLANG_LLVM_FLAVOR=DISABLE
      -DSLANG_USE_SYSTEM_GLSLANG=ON
      -DSLANG_USE_SYSTEM_SPIRV_TOOLS=ON
      -DSLANG_USE_SYSTEM_SPIRV_HEADERS=ON
      -DSLANG_USE_SYSTEM_VULKAN_HEADERS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"compute.slang").write <<~EOS
      RWStructuredBuffer<float> result;

      [shader("compute")]
      [numthreads(1, 1, 1)]
      void computeMain(uint3 threadId : SV_DispatchThreadID)
      {
          result[threadId.x] = float(threadId.x);
      }
    EOS

    spv = shell_output("#{bin}/slangc compute.slang -target spirv-asm " \
                       "-entry computeMain -stage compute")
    assert_match "OpEntryPoint GLCompute", spv
    assert_match "computeMain", spv

    (testpath/"hello.slang").write <<~EOS
      int main()
      {
          printf("hello from slang\\n");
          return 0;
      }
    EOS
    assert_match "hello from slang", shell_output("#{bin}/slangi hello.slang")
  end
end
