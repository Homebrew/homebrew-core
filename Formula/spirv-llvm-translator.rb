class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "6e4fad04203f25fcde4c308c53e9f59bd05a390978992db3212d4b63aff62108"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "df1209c7d04d52204ae1a6eb36c86043cc721cda2de4716fffe936351599eec5"
    sha256 cellar: :any,                 big_sur:       "3aa5396c0620beb8eabb4a50283d29583cf6145af561edd9b7b34a51cc591a91"
    sha256 cellar: :any,                 catalina:      "aae4b068a5b0253a4c3ef285ad29c9a5d913b75ac580339b9b5f4803df25ac16"
    sha256 cellar: :any,                 mojave:        "2eb7daf015c9a3f65f962fcb7236024e726fa42ac2939dde003550cbbe85e894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7512c36d9336cba67a1034f4911d461020d7be86f54a02204f7b365122d8734"
  end

  depends_on "cmake" => :build

  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

  # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56480
  fails_with gcc: "5"

  def install
    cmake_args = std_cmake_args + %w[
      -D LLVM_BUILD_TOOLS=ON

      -S .
      -B build
    ]

    system "cmake", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    llvm = Formula["llvm"]
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
