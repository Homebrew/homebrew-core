class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v23.1.3.tar.gz"
  sha256 "9ed57de3f31c575c836bef8f05ce5dfa98a8d80e64d948a02aac83c2e124f842"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3b90cbd19c5683973cfb07a885eb6b597da8f504814b016e9514175496a2678"
    sha256 cellar: :any, arm64_tahoe:       "1aa572ac5ef17979ff283d00789276c76be93aab4f4a8f853522cec65462e372"
    sha256 cellar: :any, arm64_sequoia:     "bd5cb529d44295fc0800fddf9ec00b6252d21f9b736dedfd155efafd649f88d5"
    sha256 cellar: :any, arm64_linux:       "c4b099bd9e0576a4729646d14ce000897080b32c7588ce7944ee56ad16809f77"
    sha256 cellar: :any, x86_64_linux:      "8ea50f4b07d1e7c881912fafb70c50a1d060fd36835e4219f08e0a522af32f23"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm"

  resource "spirv-headers" do
    # Match the upstream spirv-headers-tag.conf.
    url "https://github.com/KhronosGroup/SPIRV-Headers/archive/cb42dec3830d3ac67fa449ecdc0c0f73d5e74498.tar.gz"
    version "cb42dec3830d3ac67fa449ecdc0c0f73d5e74498"
    sha256 "117010e525fe36b1ce006e0e58a6e0a3b415aabc9179d912b92737f41f3f994f"

    livecheck do
      url "https://raw.githubusercontent.com/KhronosGroup/SPIRV-LLVM-Translator/refs/tags/v#{LATEST_VERSION}/spirv-headers-tag.conf"
      regex(/^([0-9a-f]{40})$/i)
    end
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    resource("spirv-headers").stage(buildpath/"spirv-headers")
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux?
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCCACHE_ALLOWED=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLLVM_BUILD_TOOLS=ON",
                    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=#{buildpath}/spirv-headers",
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
