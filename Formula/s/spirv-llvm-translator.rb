class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.3.tar.gz"
  sha256 "8e953931a09b0a4c2a77ddc8f1df4783571d8ffca9546150346c401573866062"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a425c821bca1ff84930051d0fdc4db1389d2609fed9fd993c6dc088d8b69e4df"
    sha256 cellar: :any,                 arm64_sonoma:  "83b56ad41ae4c697136b577db136fe4a5849d383fcfcac2693e4b8f3248ac500"
    sha256 cellar: :any,                 arm64_ventura: "e31eeeb2f387b9767a33ac331825d96fda64c45853a756a5489f25c88414e174"
    sha256 cellar: :any,                 sonoma:        "b4ce22d3a5687712eb5f7bbab2dea849f4c5ffcd17b8da4a3b80f1ee8cfbd21a"
    sha256 cellar: :any,                 ventura:       "f755ec2710b712391af6fb000c48def3e115beb2db4c4f63f0a0f5a1b8d5fe88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a81a25c23f85d2233cd3ffb2a943ef4e3ed2baee84e8ea7dc67adbc30e4c769e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7eef72a4d06e38cd2b5ce0050991a623608d8b2468dd652d4d562454d7b711a"
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
