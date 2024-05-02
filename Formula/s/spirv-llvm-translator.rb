class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v18.1.0.tar.gz"
  sha256 "78a770eff24d5ffe2798479845adec4b909cbf058ddc55830ea00fa7d2c1698a"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e48913b180bc90f98bad3635c823355a5a0b48c49e751d654c855cd9167299e5"
    sha256 cellar: :any,                 arm64_ventura:  "97895f58380e0684ab540f7feca266e2e52bc2a689d7d29851863d33aac6bff3"
    sha256 cellar: :any,                 arm64_monterey: "045b541bd73a9ad69d4c33345994a3ffcd7d30914f89225ee3b5fbede080cdac"
    sha256 cellar: :any,                 sonoma:         "a661427c37e103d0c5b5f19c85a964208dbc06781ef36f53ce12a629a7e83593"
    sha256 cellar: :any,                 ventura:        "679e1ec584d2919edc2ac367fdec3047d0bf29aabf0ced5a6edccaecffb58d8e"
    sha256 cellar: :any,                 monterey:       "1c6ef39093ddee36a686db24a1c4066022c3f2d3f73c397fd2159d354df3de79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf59cb3f763c49960422901ebe49b0cc86a91f2085f4d89d48a2f761befd5b1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56480
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
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
    assert_predicate testpath/"test.spv", :exist?
  end
end
