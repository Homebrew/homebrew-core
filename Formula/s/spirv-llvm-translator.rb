class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.4.tar.gz"
  sha256 "f6c414f9384c8f68775d9461e55e7c492f01759f5a1754f30dad4cbfb049c7d7"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "43b9ddacad2ee9e385a07bd12252d071267a027ef005bfbf20ddbc6e1ab3cfca"
    sha256 cellar: :any,                 arm64_sonoma:  "34cfbbf465218a1a52f8d7f3b6b9d3f8b88a633a721bb26fe06b8e371e96ccdd"
    sha256 cellar: :any,                 arm64_ventura: "9ea2f2f993d3344ff5d5afe074b6d0014beae2a57a24ff8ff15ca872ca4e383d"
    sha256 cellar: :any,                 sonoma:        "ae6d69181197cb0e7185eb3a7becf8c194da6187e73a2cff0e67dcb00ede4358"
    sha256 cellar: :any,                 ventura:       "89c9c6a6f68b5945ae4a77a4e45ef903aef60cf1e0a950c9702eccd0bdcfbd27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a14e131330aa2e00209a1e50944e08f70295972fbe5a3bc751b3e7654001dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d980ad9fa4920725a3de1b8678200580f79ece3eb7c5b2a332a60d3b4a9cae"
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
