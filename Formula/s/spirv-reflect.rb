class SpirvReflect < Formula
  desc "SPIR-V shader reflection C/C++ library"
  homepage "https://github.com/KhronosGroup/SPIRV-Reflect"
  url "https://github.com/KhronosGroup/SPIRV-Reflect/archive/refs/tags/vulkan-sdk-1.4.341.0.tar.gz"
  sha256 "3f55d5ad7dc6f02214633c851d4ea3872abe3a1ecec6b5d80cfc3255012c4b6a"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "spirv-headers"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DSPIRV_REFLECT_STATIC_LIB=ON",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Patch installed header to use system SPIR-V headers by default
    inreplace "#{include}/spirv_reflect.h",
              "#if defined(SPIRV_REFLECT_USE_SYSTEM_SPIRV_H)",
              "#if 1 // Patched by Homebrew to use system headers"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <spirv_reflect.h>
      int main() {
        SpvReflectShaderModule module;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lspirv-reflect-static"
  end
end
