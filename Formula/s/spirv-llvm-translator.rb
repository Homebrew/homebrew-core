class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v21.1.0.tar.gz"
  sha256 "4f7019a06c731daebbc18080db338964002493ead4cfb440fef95d120c50a170"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "516cd1b19b6b55d235bd412c4d62f14eeb4594d96e01270a625a26d538df2a82"
    sha256 cellar: :any,                 arm64_sequoia: "3bea2165fe9c6efb311333356473424b6bb6271c74add1502d5b26bdb7f5750a"
    sha256 cellar: :any,                 arm64_sonoma:  "eed9693d15ad1bfdd1d2446a95a8d0649aecb2ef9fe6f1b7e6e714e99401d5b6"
    sha256 cellar: :any,                 arm64_ventura: "8deefd61c826963f89e93f45c28b0f1bbae6b2eb6fef2bdd6116b2b5f36167d3"
    sha256 cellar: :any,                 sonoma:        "b076d4727f05f92dd434594d8acd7f1a45206bbc96b1fb59aef5e7c5f9b0119f"
    sha256 cellar: :any,                 ventura:       "194e3a3a18c5abe679de15088328fe32bcf4436cd784e72ea6fd6a347e9f1ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a3660633b0bf3750482f4ab47d3da95aa4c29d8e623902498e6a29b47876f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6b6691faf9a480ed428e8ad26ffd48b38493397a98ea3e1a8671fcab56b7ff"
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
