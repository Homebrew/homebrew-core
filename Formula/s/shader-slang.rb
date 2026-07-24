class ShaderSlang < Formula
  desc "Shading language that compiles to HLSL, GLSL, SPIR-V, MSL, WGSL, CUDA, and CPU"
  homepage "https://shader-slang.org/"
  # Use the Git URL so external/ submodules are fetched and `git describe`
  # populates SLANG_VERSION (see cmake/GitVersion.cmake).
  url "https://github.com/shader-slang/slang.git",
      tag:      "v2026.12",
      revision: "a7fbf1ab0e9ddd18b0a9eaa675ddc95f63532fee"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/shader-slang/slang.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "glslang"
  depends_on "lz4"
  depends_on "miniz"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "unordered_dense"
  depends_on "vulkan-headers"

  def install
    # slang-glslang.cpp uses the in-tree layout `#include "SPIRV/..."`, but
    # glslang installs those headers under include/glslang/SPIRV/.
    ENV.append "CXXFLAGS", "-I#{formula_opt_include("glslang")}/glslang"

    inreplace "CMakeLists.txt" do |s|
      s.gsub!(/find_package\(lz4.*/,
              "include(FindPkgConfig)\npkg_check_modules(lz4 REQUIRED IMPORTED_TARGET GLOBAL liblz4)")
      s.gsub!("LZ4::lz4", "PkgConfig::lz4")
    end

    args = %W[
      -G Ninja
      -DSLANG_LIB_TYPE=SHARED
      -DSLANG_ENABLE_GFX=OFF
      -DSLANG_ENABLE_TESTS=OFF
      -DSLANG_ENABLE_EXAMPLES=OFF
      -DSLANG_ENABLE_REPLAYER=OFF
      -DSLANG_ENABLE_SLANG_RHI=OFF
      -DSLANG_ENABLE_RELEASE_DEBUG_INFO=OFF
      -DSLANG_ENABLE_DXIL=OFF
      -DSLANG_EXCLUDE_DAWN=ON
      -DSLANG_EXCLUDE_TINT=ON
      -DSLANG_USE_SYSTEM_LZ4=ON
      -DSLANG_USE_SYSTEM_MINIZ=ON
      -DSLANG_USE_SYSTEM_GLSLANG=ON
      -DSLANG_USE_SYSTEM_SPIRV_TOOLS=ON
      -DSLANG_USE_SYSTEM_SPIRV_HEADERS=ON
      -DSLANG_USE_SYSTEM_VULKAN_HEADERS=ON
      -DSLANG_USE_SYSTEM_UNORDERED_DENSE=ON
      -DSLANG_SLANG_LLVM_FLAVOR=DISABLE
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"compute.slang").write <<~SLANG
      RWStructuredBuffer<float> result;

      [shader("compute")]
      [numthreads(1, 1, 1)]
      void computeMain(uint3 threadId : SV_DispatchThreadID)
      {
          result[threadId.x] = float(threadId.x);
      }
    SLANG

    spv = shell_output("#{bin}/slangc compute.slang -target spirv-asm " \
                       "-entry computeMain -stage compute")
    assert_match "OpEntryPoint GLCompute", spv
    assert_match "computeMain", spv

    (testpath/"hello.slang").write <<~SLANG
      int main()
      {
          printf("hello from slang\\n");
          return 0;
      }
    SLANG
    assert_match "hello from slang", shell_output("#{bin}/slangi hello.slang")

    (testpath/"api_test.cpp").write <<~CPP
      #include "slang-com-ptr.h"
      #include "slang.h"
      int main()
      {
        Slang::ComPtr<slang::IGlobalSession> slangGlobalSession;
        auto result = slang::createGlobalSession(slangGlobalSession.writeRef());
        return SLANG_FAILED(result);
      }
    CPP

    system ENV.cxx, "api_test.cpp", "-o", "api_test",
                                    "-v", "-std=c++20",
                                    "-L#{lib}", "-lslang"
    system "./api_test"
  end
end
