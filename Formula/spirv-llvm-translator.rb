class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v16.0.0.tar.gz"
  sha256 "305fac5bb8efdad9054f0d27b5b765aca8b3349a500e2ba0c927763e42badc2b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "33089120098629f38fc95bf77e546b88621fc17d728a1ac1696e9f3ed0d05990"
    sha256 cellar: :any,                 arm64_monterey: "8019ed273411a8735364c93f62ee983453b6d6e3537b26e5c1276b6fabc8ee4c"
    sha256 cellar: :any,                 arm64_big_sur:  "08998820e25b83bc260fb003a804bd1a48d45b8d5d1a59cb7fc855bc4aeaebf8"
    sha256 cellar: :any,                 ventura:        "452c59b3c06adb9fee5b6994f5ca671e9613b9496f9fb123438232b91accfdda"
    sha256 cellar: :any,                 monterey:       "7a651c2959c2599b8566672a2a673b3b57fa063aac59c9a52d65346cdff06348"
    sha256 cellar: :any,                 big_sur:        "b11a428a3045237d0b7208c85e420a6020337004dd07de66ce44804ad3a9a17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b47b6b0a422ea03383704b5fdf61703bcae7f72249f640a478db25780e49d3"
  end

  depends_on "cmake" => :build
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
