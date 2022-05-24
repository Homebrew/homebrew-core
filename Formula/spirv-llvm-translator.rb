class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v13.0.0.tar.gz"
  sha256 "b416c06525c8724be628327565956c418755fbb471b4fe23d040ca56e1a79061"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1d456f3222c431416e1b44700c2d82c7292aa678326506e7b351706985d9ee2f"
    sha256 cellar: :any,                 arm64_big_sur:  "92e5cd447c4697efb1426b15971cee928c5352e0ba7c3ba40c0e258290e2eeec"
    sha256 cellar: :any,                 monterey:       "cbf2377048c5b50dbab41c60baea31604c9bae41d3d350ee5ae66ede16c46ea8"
    sha256 cellar: :any,                 big_sur:        "7c1833d0f5f8160fdb143eb2ef45a8e501f5c4558e4adf99ed5c05dff778d751"
    sha256 cellar: :any,                 catalina:       "3f6aadbe72ef0487be0bcbe21612e2c50f5b91eb17ae0a4364ebcd0e86864e97"
    sha256 cellar: :any,                 mojave:         "879aa8f4b115e9f854f08b0bca109c733c5cef1a05c3af151b295a02a759fd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "474b5dd87cb87ec81fea6028e8ec6736626e7a70e7440cd647073c785374c709"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
