class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.2.tar.gz"
  sha256 "8c91542b579a3b27b7aeae1db12004eb412c9ed9bdff0a29ee862c3551cadfe3"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b433cf150af8c0d5d3aefc23befeebdc8e6b14f3cf9040f68527abfdc28e5258"
    sha256 cellar: :any,                 arm64_sequoia: "6dd67b03ad4d82575fc85d2f5b339a653078bcd22d0f22f2f957804471166792"
    sha256 cellar: :any,                 arm64_sonoma:  "01bea0a098167e495b468347b7a6bddfa64f1aa7957b1a7edf04c7cebad9c294"
    sha256 cellar: :any,                 sonoma:        "6f1da4ec580ca6db8e102caa88d5d4ea4c36542d82e091e6d2518920097904ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93c2ce103fb4548da20d7a089641e3879dc10ad83dc12ad7da8c06098cc21a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "957ad4f6b409706f8171f1b7a95bc58d8d13b0e40b0d15b053d2bb2e5ea6c958"
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
