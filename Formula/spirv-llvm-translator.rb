class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "b1bebd77f72988758c00852e78c2ddc545815a612169a0cb377d021e2f846d88"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "080883216778e904458b872f6bf66a11be2aafa4618e9a09ad67dc4932eca1f8"
    sha256 cellar: :any,                 arm64_big_sur:  "222a404360350f7f3a498882e74adeac6118c39ab21aff5caeb913d453272581"
    sha256 cellar: :any,                 monterey:       "65c90b93e2649a7fa4d28c45902a768f6883068a6f6ad1f7a5713abd9ac1f9bc"
    sha256 cellar: :any,                 big_sur:        "e1a94df6543392c2679b0d0e9e65201e69d9b9542c72a5d9254c05cbd2805a11"
    sha256 cellar: :any,                 catalina:       "eab80f7162c66b933b6041934bab45f9aee1aaa53e26e68c777bdec5f993c612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec199d4e665b66f9ee4c6d23cc4ec9add293efdb7c3f1a75967d4d9aa50a2308"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56480
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLLVM_BUILD_TOOLS=ON", *std_cmake_args
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
    assert_predicate testpath/"test.spv", :exist?
  end
end
