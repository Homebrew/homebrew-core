class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.3.tar.gz"
  sha256 "43080fd5122c71cd93a3d174d59b9fc95ff8aeb1847d50f394088112f6b2a217"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7c3b4a41d4c90a16aee2e471cc9a72d9e10a03c3963e7323918fd8afe1086a2"
    sha256 cellar: :any,                 arm64_sequoia: "5c18c6f2c26a6da6e55e6d281e78ff376f4976a1c6d87693206c28a2fab52f1b"
    sha256 cellar: :any,                 arm64_sonoma:  "65cde494004ee82508d4952af82973af8c3471c81bc7b627a9896b4f95508d18"
    sha256 cellar: :any,                 sonoma:        "3c309a355266d3aefc4297261883ee9aee3d056a290ef92c9010ea1d14e69011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8580521f3cccbfeaf9583dd0c036920842c51988995c8dc2e917139dcbb0cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21d6ba7c7cd2a094834b1027efcd9c4715a31efc96c62e915b836cbbf43be293"
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
