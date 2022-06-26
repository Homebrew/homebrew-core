class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "1afc52bb4e39aeb9b5b69324a201c81bd986364f347b559995eff6fd6f013318"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "624e78d249e32eadd7f878a1614f48d6221b7c003ca1320d1caf7a26e2ce17bd"
    sha256 cellar: :any,                 arm64_big_sur:  "77a011303bed9649122aaa2e8e525524009bbb37aeac323f01eebd7024466027"
    sha256 cellar: :any,                 monterey:       "a93b9293ec484e764a2b7d78a7e495408cdeb0f34e82f6f323e2dce2541b277c"
    sha256 cellar: :any,                 big_sur:        "b8b5cbdda3d0e86c9fce82a49e7b7c8b7d1ed1a7004071d4c391550e0cd8545d"
    sha256 cellar: :any,                 catalina:       "986f6173f32dff93e402476eb29107b4e191f2f2ee6af3e8190a02e184454e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e595c8944ed32fa7a100a2091b1de0d23aa3530c0c728f9d4d9e1aa25353ade"
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
