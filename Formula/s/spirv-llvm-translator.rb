class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v18.1.1.tar.gz"
  sha256 "c1c7aee4ea23a6a1089bb7f7bad198c28ada65c5b7671434562fe0241d8674d6"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ce471b671cb01fa1b214001fe939df53e04735cb06d1ced7c739657245296e6"
    sha256 cellar: :any,                 arm64_ventura:  "6362fd27e9566bf4ce0a679faebb4b0dedf6082bd584d0bb9c24acc685b1733b"
    sha256 cellar: :any,                 arm64_monterey: "660250ddca7ea4b02f09ad3197223df13ad684cf48a4038f0aef7a94b5c92645"
    sha256 cellar: :any,                 sonoma:         "a4b400b660b934fd00674421aeb130adec57015e023c50951fb043c5b758c388"
    sha256 cellar: :any,                 ventura:        "75c7fa3d6ad029fce0678a818db69ee4a36f821d79ca9981301d46702d43b386"
    sha256 cellar: :any,                 monterey:       "a3ea3f2694b7c406c0440d3e8bf2790bb228a01204ab0bdbd70db536d89fb185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9024ba3b0ff0020befcc5704056014892b45da17ab357998195a649bf79372f2"
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
