class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.27.tar.gz"
  sha256 "63a18acbd02f2402693cb3d38ece5575c411ac033c8fb3d86ff5de5a5a8fadbd"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2d54749d6875543565c89823213fa0e1711b0b2287411659367868f6342b364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2432a766327ae26453cba3aade29a97bf0f530cfa0198f09ecc1bf10b5377371"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cdb4d517bad1d6ec21480542e9eb99bbae0f3ada1a998f22133db2fe2b8ef4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e00ad19c1a8fd2786f7b155ab1ef22103cf2b55cd84c60b196909fbbc34c46c"
    sha256 cellar: :any,                 arm64_linux:   "79e87598fdbb93ce09c3b7908a2b4ad96a559c172556ef11c9ff1ba9c4d8971e"
    sha256 cellar: :any,                 x86_64_linux:  "9d6468b6fb4f24419f41c380e4d927d98fbf1ce5bc8136b8cbe009989ab645ef"
  end

  depends_on "rust" => :build
  depends_on "lld" => :test
  depends_on "llvm" => :test
  depends_on "wasi-libc" => :test
  depends_on "wasmtime" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "builtins" do
      url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-24/libclang_rt.builtins-wasm32-wasi-24.0.tar.gz"
      sha256 "7e33c0df758b90469b1de3ca158e2d0a7f71934d5884525ba6a372de0b3b0ec7"
    end

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc

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
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasip2"
    (testpath/"lib/wasm32-unknown-wasip2").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{Formula["wasi-libc"].opt_share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end
