class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.4.tar.gz"
  sha256 "e900c907b62f82cf541a611b33d6685f375fe3bda6f041087fcdba350ffb437d"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "799e96c4c0dd3c8d53133f586eb1e6ab3c969b638981bcb314788778ffde8df2"
    sha256 cellar: :any,                 arm64_sequoia: "83e0e7267fb45710bd3a4bea1d432b349f0acb25fe843ed88d69d966b407c64b"
    sha256 cellar: :any,                 arm64_sonoma:  "33d1b3462e66dcddf8ca17805fbf9a99b97d221eeb4dd444ee801f0f3a3a0953"
    sha256 cellar: :any,                 sonoma:        "bee21ac2bfc8a0aa7135c527305e512b35daecf012673dbc2f7a8bbb88828117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3e464e528f4e777060a5a624394b3c7f3a2feb4e9769b057a75cb9580435475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07c7483404ef9fcdfd75ac09bb0ae35c4187f84f18dce4e39a4f622126b66aa1"
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
