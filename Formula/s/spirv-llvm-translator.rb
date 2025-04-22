class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.1.tar.gz"
  sha256 "3b2a750bbaea4a084e90fd88de317f9a03879056e3bd429bb56c588f4c77ca16"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e4df410d0f8ef2418fb057bf1ecc7054a4c2375c1744add461ea57ac6196644"
    sha256 cellar: :any,                 arm64_sonoma:  "746516862dd7f77d59586d4a4643d2a7b91aa4414a3f071ea6ee316788a7d9f7"
    sha256 cellar: :any,                 arm64_ventura: "a8959352413b62b63ce21009cb31278e804403c11b9f17707c5536934485dffc"
    sha256 cellar: :any,                 sonoma:        "233093ce6151ff3131c21887181e4f9e2173b54ef55b2c245a03001a0c803bf7"
    sha256 cellar: :any,                 ventura:       "7227fc7896dcf4c6d3122ac7b5e9e5b9221fb78a8f4e20561e6451c244445efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165991c351f541f2ee1d45c6a94bf981d9de08ae6423aa678d3331b4c5b1eeac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85275316a4d56884c14c428c6e617d3880eb93e504e4c951ce81c2e8780fd6a"
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
