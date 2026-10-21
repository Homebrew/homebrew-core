class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.31.tar.gz"
  sha256 "0ff2469fe15d674a1430d1b851f899c5511bc57f917fd7a5949d8c73f417b7b4"
  license any_of: [
    { "Apache-2.0" => { with: "LLVM-exception" } },
    "Apache-2.0",
    "MIT",
  ]
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e815f44ca0906c1ded20fbaf406fb5474bf307fc068b906bf3d4607ff466a082"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3dbfb3d23ab7f6ad8cf353b87ae7b4b4a8bae3617de5255e0d2164666d3e919d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f69fc2c92272f318c51b78620e66c8370fc2642a0abe6edffae08df1e7d81b9e"
    sha256 cellar: :any,                 arm64_linux:       "f7cd5060d7784b6c8dbd3cb96e93ff02a3016f6e8b4e27aa83b1c945d64b31fd"
    sha256 cellar: :any,                 x86_64_linux:      "59ea45f4de76123c0af060ad140f66a2c7313966d5a44b38b2d75a568d519c93"
  end

  depends_on "rust" => :build
  depends_on "lld" => :test
  depends_on "llvm" => :test
  depends_on "wasmtime" => :test

  # Avoid a dependency loop by using prebuilts for testing
  resource "builtins", :test do
    url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-34/libclang_rt-34.0.tar.gz"
    sha256 "eee3e634dcf71aa22b1333391623cf5c9965a637dc428a27b1a858c026c587f1"
  end

  resource "wasi-libc", :test do
    url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-34/wasi-sysroot-34.0.tar.gz"
    sha256 "9d813544eeebe38b7b8f2244ed591de46b6db812c6dd1a257ff9f0d2a905a2be"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
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
