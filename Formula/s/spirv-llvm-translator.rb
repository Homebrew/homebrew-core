class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v22.1.1.tar.gz"
  sha256 "83e7007b8b9b5536b30991661738a98e9cd607d4a203e9342b628aaea5ea32d7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0449829fa7e6508f56d170a06eb4e09e061a7881204320ce7f9e5605095e915f"
    sha256 cellar: :any,                 arm64_sequoia: "13c2961cfaf8a1efc7e6399ae54a5fe406057467fa34148430e51eff781330b2"
    sha256 cellar: :any,                 arm64_sonoma:  "32266f6bf7ca04c30d41bccc9ac6cc68ef702d0546bf4e3c569199658dc27c71"
    sha256 cellar: :any,                 sonoma:        "88a98c59819d15d57ff067cb0a663c5229515576d0cae2090f2ac5ec115300c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d6cfc4286473184465ed15671fc2db1a0eae264b30819b7864a295578716eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38e548399334d8d8fcd63b2576aad033c2dbf3e60e83eabbf75fde01d2589441"
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
