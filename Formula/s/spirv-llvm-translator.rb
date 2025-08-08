class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.0.tar.gz"
  sha256 "4f7019a06c731daebbc18080db338964002493ead4cfb440fef95d120c50a170"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97f244193ca29f8f04d91061eec5af361a2ad500cccf6db042acd62b95a4e404"
    sha256 cellar: :any,                 arm64_sonoma:  "bfbb8ac72c1cac816242462ad7855d382b9948817b726e15f44157701ea02074"
    sha256 cellar: :any,                 arm64_ventura: "423dbc7c9eafdc35323a1e4b9159b7a2b315007f505c845d3d7f89dc261a4385"
    sha256 cellar: :any,                 sonoma:        "1fc43505c08f35d00d59e96ad8af93bef3cb47d27e2d4b7875b762ca8303ad4e"
    sha256 cellar: :any,                 ventura:       "f61beeb55a1433ee58867107294ee1ffccda13ec6d95ef9e247318479b002612"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32cc58a0975b5d119b8ae4ce6a917f7da1abccc239e6cf1977eef804816a3515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f7b3b3c7c0dfbf665fc92a87f1f607402ce97203406fc82ee72e6bd05bbe6b"
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
