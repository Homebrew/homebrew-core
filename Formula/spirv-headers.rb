class SpirvHeaders < Formula
  desc "SPIRV-Headers"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/vulkan-1.1-rc2.tar.gz"
  sha256 "cad18d4f05dee13976741c379f042d0d21562bd03e9f0e1496221e2682acf052"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install-headers"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      add_library(SPIRV-Headers-example
        ${CMAKE_CURRENT_SOURCE_DIR}/example.cpp)
      target_include_directories(SPIRV-Headers-example
        PRIVATE ${SPIRV-Headers_SOURCE_DIR}/include)
       add_library(SPIRV-Headers-example-1.1
        ${CMAKE_CURRENT_SOURCE_DIR}/example-1.1.cpp)
      target_include_directories(SPIRV-Headers-example-1.1
        PRIVATE ${SPIRV-Headers_SOURCE_DIR}/include)
  EOS

    (testpath/"example-1.1.cpp").write <<~EOS
      #include <spirv/1.0/GLSL.std.450.h>
      #include <spirv/1.0/OpenCL.std.h>
      #include <spirv/1.1/spirv.hpp>

      namespace {

      const GLSLstd450 kSin = GLSLstd450Sin;
      const OpenCLLIB::Entrypoints kNative_cos = OpenCLLIB::Native_cos;
      const spv::Op kNop = spv::OpNop;

      // This instruction is new in SPIR-V 1.1.
      const spv::Op kNamedBarrierInit = spv::OpNamedBarrierInitialize;

      }  // anonymous namespace
    EOS

    (testpath/"example.cpp").write <<~EOS
      #include <spirv/1.0/GLSL.std.450.h>
      #include <spirv/1.0/OpenCL.std.h>
      #include <spirv/1.0/spirv.hpp>

      namespace {

      const GLSLstd450 kSin = GLSLstd450Sin;
      const OpenCLLIB::Entrypoints kNative_cos = OpenCLLIB::Native_cos;
      const spv::Op kNop = spv::OpNop;

      }  // anonymous namespace
    EOS

    system "cmake", ".", *std_cmake_args
  end
end
