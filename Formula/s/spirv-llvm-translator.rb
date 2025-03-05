class SpirvLlvmTranslator < Formula
  desc "Tool and a library for bi-directional translation between SPIR-V and LLVM IR"
  homepage "https://github.com/KhronosGroup/SPIRV-LLVM-Translator"
  url "https://github.com/KhronosGroup/SPIRV-LLVM-Translator/archive/refs/tags/v20.1.0.tar.gz"
  sha256 "ffca6b2aa53076ef85a09676ef0079877cce4977d7aa64f5f5b33596c7d1d285"
  license "Apache-2.0" => { with: "LLVM-exception" }

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "801e35556df4e560113a5170d9ee2fc4fa869a1d665c565e0eb3138b303cf59c"
    sha256 cellar: :any,                 arm64_sonoma:  "88875debb4ec50a35b463f63d1c4c3cc26b7f724ef5d82449ff740fb76d439c3"
    sha256 cellar: :any,                 arm64_ventura: "cab295465cf0e1449325ee52bf913f5e5a43abb2843c9adb6431c92e9a01999d"
    sha256 cellar: :any,                 sonoma:        "d868a34f9ade1b66f93ed4f26ddfe5a589849b57b3f2524ff90f3cd2f228545b"
    sha256 cellar: :any,                 ventura:       "c4c902b3f5f7f3288112296feb0f344752081c9909d5675d947de1009e4cadf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b620ca2dd90050f572d1c20764a41f021975f4cb7bd74c3f749667333054aa1e"
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
