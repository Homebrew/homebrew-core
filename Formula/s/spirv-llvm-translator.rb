class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v23.1.1.tar.gz"
  sha256 "9e0bf1beb0ab7edca6cd8c17fd9bbb7ce3dcd520f3e969e0485ff5b00931f929"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "62b81746af2c3e2bb32c72106af08ee8b0c9651285496ffbbd79ff9b4da9d792"
    sha256 cellar: :any, arm64_tahoe:       "bee3764d7f2b6fd3d88140809238dcf1a16f847c3e36308d8d0d3c4f9fffa2a7"
    sha256 cellar: :any, arm64_sequoia:     "7b77d68313b19de5f2d7eadaa7b94597dde5b9302436b8e422f8e80efc99be7b"
    sha256 cellar: :any, arm64_sonoma:      "e70ff3c3d6b0d102ac5102189d955bf57bc30c31277d8f179fbd2b20f9b71448"
    sha256 cellar: :any, arm64_linux:       "650afd4748908eca7fe58b201ba12798789f3d1ba0ac2ce30a791770b72a387b"
    sha256 cellar: :any, x86_64_linux:      "c01df8e2ce807bf1e8ab122161999550dcb5f3da90c4ace9beb23de3ecf5a8eb"
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
                    "-DCCACHE_ALLOWED=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLVM_BUILD_TOOLS=ON",
                    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=#{formula_opt_prefix("spirv-headers")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.ll").write <<~LLVM
      target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024"
      target triple = "spir64-unknown-unknown"

      define spir_kernel void @foo() {
        ret void
      }
    LLVM
    system llvm.opt_bin/"llvm-as", "test.ll"
    system bin/"llvm-spirv", "test.bc"
    assert_path_exists testpath/"test.spv"
  end
end
