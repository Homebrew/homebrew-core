class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "b1bebd77f72988758c00852e78c2ddc545815a612169a0cb377d021e2f846d88"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2df5901e5c9eea1315a27cb8c3330a946b05b7d4d2538b6e0f590dc3ca0bcc97"
    sha256 cellar: :any,                 arm64_big_sur:  "33b49c70646d20ecd522d190dec8c643d55540f67985dbd7df1a055273cb754c"
    sha256 cellar: :any,                 monterey:       "cb8804299aa67d0ea789db37a3db18dae89afa8ee5ebe6dc6c8954c3999ee709"
    sha256 cellar: :any,                 big_sur:        "6af8b0a485a97d1f720ff575c0a123008c22c9a4473a561b2347c791c584eae2"
    sha256 cellar: :any,                 catalina:       "4edef5f53e5a309545ed47d72124c9c20418f39e20864d227bd9fcce35c585d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31dc55f53ff4e0e57d0019a1e837d0fdd641a09ffc2ec2d964b8f14f6fd672ff"
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
