class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.2.tar.gz"
  sha256 "d1b4a55dc457edbd9cc50d23583d4bedda9479176efcd34b3e20166bc7a4a562"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d2d662b60a4779b1d54609ac46961178069b78d3b5e29dc392d83f0bb2f77be"
    sha256 cellar: :any,                 arm64_sonoma:  "030ff2cf482f2e4e047be915ba875027ed903e2a1c076efac8b73f623c37a13e"
    sha256 cellar: :any,                 arm64_ventura: "c249699bf1e4f4302d1785848ed3a6c14b82b42c4384cc08154ed39634c106ff"
    sha256 cellar: :any,                 sonoma:        "b101621e10e8111828626a444a70081d5a4d7dbcc5eb530248a8f7eb8d3c285d"
    sha256 cellar: :any,                 ventura:       "ad4ccd7cdeb3b8acf6833f025b52932eef992dab584010aa975429737d5aff33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71bfa085d672dd0050427be679576f5870d51402952033c05d07f65c205e94e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26e105772ab373a0810b545b4d6a3829845d67e8656456fc292e9bf9823aa371"
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
