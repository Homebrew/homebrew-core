class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.1.tar.gz"
  sha256 "dda46febdb060a1d5cc2ceeb9682ccaf33e55ae294fd0793274531b54f07c46b"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d942ac770e34477fd1e0504ee101d5958829f4c325f4c5a3149388b951668b22"
    sha256 cellar: :any,                 arm64_sequoia: "8c95e5988672691a13850335435e5909fe97cd030cb4709588633f2554f2d6d5"
    sha256 cellar: :any,                 arm64_sonoma:  "e53665e81c97d9448fd2d30a8232d07326f7362bf4994190009fb205929abb0e"
    sha256 cellar: :any,                 sonoma:        "1d02b3dfe148e926720944e163404c1037e0c6f7161fc1b16469e6717f0d006e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572dccf23605f62e8e6dbdc54e1aec62bf000e9cef6092865aa8ac2019ca1f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de849b0a2eb42453fb5d2c84d5ff13184614ad0bd3739b5b946e9dc020e3ad1c"
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
