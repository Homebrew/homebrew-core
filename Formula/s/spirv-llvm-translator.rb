class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v22.1.0.tar.gz"
  sha256 "a5d476404ab88ac0d148211da50428178c89caef8af8042a3ca8e71e58ed9427"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "966dcbc340c5a1dde90684f6bd65e50df47ac69d832b992384ac0667170748d4"
    sha256 cellar: :any,                 arm64_sequoia: "91c12287f7da19448667091bc486fa8802bc3935f1a0c36fa83fe462910bb14c"
    sha256 cellar: :any,                 arm64_sonoma:  "73b8c0b86c44d643b9561b0d0f42163bb96b50f0db2b9f9414f10a85a98547ff"
    sha256 cellar: :any,                 sonoma:        "24eb73763db6e832ea4fcc7199ebf4ddd60993adca15ed5e142bef2031c1966c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "905eb3db62ca27e026f8cfc7ca931ebaf1fcca40478ecda51f5a8db6c9a58420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "896dfc92eca87a325b98b440482f32948bba02ec80a6101631091d344ffee1da"
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
