class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v18.1.3.tar.gz"
  sha256 "d896f35102c3ba9e16ead7b4db53b75e6131982cdb36a3324f17c68a43598759"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e49ee17d67a1620d075cc0976892607f789aea14339f11ee88b3bf962d2a55c"
    sha256 cellar: :any,                 arm64_ventura:  "079d3f9b9cbdd49b1dd0c825906651b66e7ef8fcd80feaf4c6b62670676ae590"
    sha256 cellar: :any,                 arm64_monterey: "7fe22690d011a5ac6d51da0efc7f51e13ceb12c038e9e2ecb16aebd5d7f498f2"
    sha256 cellar: :any,                 sonoma:         "a6137acd6376ee0293dc1de61c15032fea9a1914eda8d86ddb7464709eb91304"
    sha256 cellar: :any,                 ventura:        "1902a1db6333398c396269e70547ecefccd4ce4fdb8e9fdf4c306d78bd2b8b39"
    sha256 cellar: :any,                 monterey:       "5cdf5bba5eb794075c397341f97c4fd2523c101a5e2966b37f68e83aa16e881b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8626a73478349447ef64efd0d8615b86ab862c7bc06daa7ca14d16ed2d038da1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "spirv-headers" => :build
  depends_on "llvm"

  # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56480
  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
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
    assert_predicate testpath/"test.spv", :exist?
  end
end
