class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.11.tar.gz"
  sha256 "323328b18a1e13e35e36339ce59c6e7c4d1800b4fbdd78ba6fa83f3358324414"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9538db2e80d4542314ba1e901e554a9945bd9efa27bc439346ebad52aecc1869"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8027d24b5aaa33a84ef04f5c9b3d1e93a6d5817daf4d2c5fdce9d8bcf6f9e383"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b6133d9717b3c9c69facf38d27428c65b2a8bf1e985d004d09c509c126e6ef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f1629dc9d3302a738ce7d031e2fa02dbfec7fb7be3875876dd2345d0bb5019"
    sha256 cellar: :any_skip_relocation, ventura:       "4b7474c8215ad08736c2a15563faf73118e41f1ef71090875bddcbcc51f5786a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e070bde431c6cf413bd849260b369b5264b5dbe66052a87699abb616db927086"
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

    clang = Formula["llvm"].opt_bin/"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir/"include"
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasip2"
    (testpath/"lib/wasm32-unknown-wasip2").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{Formula["wasi-libc"].opt_share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end
