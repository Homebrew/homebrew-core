class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v19.1.0.tar.gz"
  sha256 "2e64231db8646d8c220d44136712549b5d4c4194c6ce0e57c4f5ab342beee9a2"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1e1ea25bca360dbccac89a44cbfa4bf15149ed6fa55705adf967fdfb0b242bfb"
    sha256 cellar: :any,                 arm64_sonoma:  "394b8ff05d67d990a80a3233e5d7d2ba7971866a2655722c264757b6b47d2344"
    sha256 cellar: :any,                 arm64_ventura: "970fd5b11b71181316fd0745fa0b56ec16e1c85931661fa67700c69be23e3e5d"
    sha256 cellar: :any,                 sonoma:        "f50723f11d988cade73b5dcc3854a9a78ffcba09c059907d3e680b5e5d47f674"
    sha256 cellar: :any,                 ventura:       "004186cd11e65065ea321f8ced16b392b9de9da5331536a7f87777abe14b97b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8685364941984a8503bc8f47d98c5307bcb415bfe5dc3c17b6f6978e9aba2e2a"
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
    assert_predicate testpath/"test.spv", :exist?
  end
end
