class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v19.1.4.tar.gz"
  sha256 "8f15eb0c998ca29ac59dab25be093d41f36d77c215f54ad9402a405495bea183"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5eb10fb69bb946e25288b9337dc2b1a1c9fd68866086a1de20caf81de6d0407"
    sha256 cellar: :any,                 arm64_sonoma:  "cea0245fedeaed2fcdaf4c0b7378fe4562e5eadb64b2250af7d37490cf928302"
    sha256 cellar: :any,                 arm64_ventura: "03f27c121012ec284115979242b73922573daba9241ea14df78ee5dc78eab17b"
    sha256 cellar: :any,                 sonoma:        "ffdfbaad3b2629eb0299922f8818fffa15dddf41b7ec56044fa023c0f1bfc89a"
    sha256 cellar: :any,                 ventura:       "e6c7a76b232383d8bc1842f9faad26bfc34142d6fe51bf0919470226c8a13285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0b3e628db64a0d120b085974e59d2fe65f27b6cc21a9bfbfe352399ac420cf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
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
    assert_path_exists testpath/"test.spv"
  end
end
