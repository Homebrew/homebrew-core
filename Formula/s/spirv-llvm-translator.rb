class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v19.1.3.tar.gz"
  sha256 "cf702ec5a1c8e1ac3bfc999c1207e753fe8f972cb7d9608110b2f54ac4f0572c"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea6973155952cf893afc7ea46da3404503e0300c3e6d2021477c314db93479dd"
    sha256 cellar: :any,                 arm64_sonoma:  "64d2e3570ef652b3dcbe87cd6f96b07bc35c55995a5ee5a2a36e0a7c5dc2ab00"
    sha256 cellar: :any,                 arm64_ventura: "5127a251215af57f26ff1a8014a3bf9589b85631906d1d3bad737aaf53c4c267"
    sha256 cellar: :any,                 sonoma:        "1f09a8a96b309c5db532752e4fbb9952aaf5421de5e598740d0ef0ff9aa8a3c8"
    sha256 cellar: :any,                 ventura:       "ce421c3b374e58f054317878d65c1abf6573cb52c7720299d0c8359c1fb9f2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b131ee37d4abef7c7f3ec961fc876359d7126efee2fc2e168342071cd249f174"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLVM_BUILD_TOOLS=ON",
                    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=#{Formula["spirv-headers"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.ll").write <<~EOS
      target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
      target triple = "spir64-unknown-unknown"

      define spir_kernel void @foo() {
        ret void
      }
    EOS
    system llvm.opt_bin/"llvm-as", "test.ll"
    system bin/"llvm-spirv", "test.bc"
    assert_path_exists testpath/"test.spv"
  end
end
