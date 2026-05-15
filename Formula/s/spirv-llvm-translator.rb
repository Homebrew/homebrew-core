class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v22.1.2.tar.gz"
  sha256 "b37196b1a1a60282a24cf937ab7d6807d7d54dc718f2a37a78e211be26df57ac"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "733f34bb4555268780bfcee98fe752ca46ae1f51fa00e91eff9616b2788aeaf6"
    sha256 cellar: :any,                 arm64_sequoia: "5bf5560c2446b57bbfc36112e3a0e807c2ee58cc8dd8c2c31b0a3e3209705516"
    sha256 cellar: :any,                 arm64_sonoma:  "fab3a5685fbb250058125104ed5d424794d9884e35037b2c19eb24157a0d8bac"
    sha256 cellar: :any,                 sonoma:        "d4f8e346bce4915a97a67b42c37bf2daf1c06b1653bf7128b47f744e3c5775e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b6428af732a948b54e3873c1bdf9907acae3e41f0a4212029e89fcc0e402a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93733fcfe6dedf795666e92e9099277ad4b5dfe815788517feac3a3e7923152b"
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
