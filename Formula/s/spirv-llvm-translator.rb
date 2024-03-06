class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v18.1.0.tar.gz"
  sha256 "78a770eff24d5ffe2798479845adec4b909cbf058ddc55830ea00fa7d2c1698a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb08f283d690ee4edd312aaad2b8a0c7f0c2fbd3cf98f34390f1af9a670650de"
    sha256 cellar: :any,                 arm64_ventura:  "d3aa7e4ab52318d5817ba74dc88872b5e5eaea275895defbb362bfd544f8f674"
    sha256 cellar: :any,                 arm64_monterey: "f0ae081b3fcf344299a2c188a5a3d22edfbe688fa502f6becc01a96e60f48d79"
    sha256 cellar: :any,                 arm64_big_sur:  "2afb73ee7cff207e91ca52c5ec5a9a9e07862aa538f4ebbec0fffcae4f3650a2"
    sha256 cellar: :any,                 sonoma:         "2c74a9a13e149870a414f3a34e8d5f4be3f528489bd09fe0e2cc0e554dc28e90"
    sha256 cellar: :any,                 ventura:        "c72f01cafc7dec197aa30a77f6239fa334408749d095b5b9b3cbce3dce6d13e0"
    sha256 cellar: :any,                 monterey:       "af50fdc162830bff76ffa70abce9eed9656d6a30a0319637e6da01d48459c756"
    sha256 cellar: :any,                 big_sur:        "d31c664d90e519943c2804e8980df4876314bb87756f8abf9fe6cee51bc652eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c37b469b72e54d21f3eb58ef356c9a8d052589cd768ac3d7382cd385677b43a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56480
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
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
