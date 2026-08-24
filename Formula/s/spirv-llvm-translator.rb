class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v22.1.5.tar.gz"
  sha256 "3c6dffb4b8d67f5c544370e0c869ec7d22c013d4bb798f24655ec903f26cc5d5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f472360899fd302ed7714a2610fb1139df585ce39f940201f6b39df7685199cc"
    sha256 cellar: :any, arm64_sequoia: "a1d0f75536ce0489a57c9908761ba560bb0c33b4dd3e45a34da0a294f966dbc8"
    sha256 cellar: :any, arm64_sonoma:  "7fca1ca6c6a9c1f20691d9861ef87c19fe7c1b274efebc6544214226797dc9d6"
    sha256 cellar: :any, sonoma:        "07b172978601651fec24066c29e3eabb41c1412dfc75da54008e79916f0f85cf"
    sha256 cellar: :any, arm64_linux:   "e79778f6c41e607386dd7fe99c2a4232ce772a02b15db4b5f8a857465b3e913b"
    sha256 cellar: :any, x86_64_linux:  "b09d08c8484b090ca04b45d6544f0b36fb135ab96a5bb1fb27ad1b6b5925d7ae"
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
                    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=#{formula_opt_prefix("spirv-headers")}",
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
