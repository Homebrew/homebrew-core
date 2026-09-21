class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.30.tar.gz"
  sha256 "d5e9b986da0807b3059c32cf56690933b93ef910226ebb08ceb434397446fd0f"
  license any_of: [
    { "Apache-2.0" => { with: "LLVM-exception" } },
    "Apache-2.0",
    "MIT",
  ]
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c74889cc4c4346b56a22a4a05fb7edee32e246c6023270ec27155795fef98472"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa08b67f61302c1341db1ce19fed71aec3e23c3c8f2438449507c086733c8ef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "df64a3ebcf842733192d4df93f03f4715ec8b2119487016a04b9e84d01f80dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f1968db74abcccf0369442038fbe516afdd148ceee96e929990e08fa9c691dd3"
    sha256 cellar: :any_skip_relocation, sonoma:            "48fcfe5bea3cc267a0fc7ac60c496a41ca67a1247a58557cfea1d423cb5186f0"
    sha256 cellar: :any,                 arm64_linux:       "6a49cabf8f30b1411c41626e10ef4a0a78115fb0d5c7034441d36c48d3e9ea66"
    sha256 cellar: :any,                 x86_64_linux:      "2de5fe408456450bd9bf8a16e4954c7ee8389dfdba3adb0d3327d69ca7d4442f"
  end

  depends_on "rust" => :build
  depends_on "lld" => :test
  depends_on "llvm" => :test
  depends_on "wasmtime" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Avoid a dependency loop by using prebuilts for testing
    resource "builtins" do
      url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-34/libclang_rt-34.0.tar.gz"
      sha256 "eee3e634dcf71aa22b1333391623cf5c9965a637dc428a27b1a858c026c587f1"
    end

    resource "wasi-libc" do
      url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-34/wasi-sysroot-34.0.tar.gz"
      sha256 "9d813544eeebe38b7b8f2244ed591de46b6db812c6dd1a257ff9f0d2a905a2be"
    end

    resource("builtins").stage testpath/"lib"
    resource("wasi-libc").stage testpath/"sysroot"

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc
    ENV["CLANG_NO_DEFAULT_CONFIG"] = "1"

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      volatile int x = 42;
      int main(void) {
        printf("the answer is %d", x);
        return 0;
      }
    C

    clang = formula_opt_bin("llvm")/"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir/"include"

    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{testpath}/sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end
