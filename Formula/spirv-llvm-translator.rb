class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "6e4fad04203f25fcde4c308c53e9f59bd05a390978992db3212d4b63aff62108"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9bb7cd5741a9992091c5ff737d20c0de83671427be30d7e063fd7b92b7667f8f"
    sha256 cellar: :any,                 big_sur:       "2001d96783379a0701d03728fcf007ce3870e37e8faac26e2f869ed8156835d0"
    sha256 cellar: :any,                 catalina:      "33674cba9e6be10165706e14f252f0d9507d04c6db9c437364cf02c308cef4b8"
    sha256 cellar: :any,                 mojave:        "efde7cdac01766aa3bf141af421b6dc120509eb16372d9c54ed3cf14a2595431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48893499d95a76f600ec69ee62b817ebcae457ad401d64612cb06dddb6bde03a"
  end

  depends_on "cmake" => :build
  depends_on "llvm@12"

  on_linux do
    depends_on "gcc"
  end

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
