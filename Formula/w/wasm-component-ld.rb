class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.12.tar.gz"
  sha256 "d9747c922bdeda3490405d62669d3d74c4dc39481a10e5302db6deece768623a"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b720830590021a16b3e47aa74b1de0e288d971e0c92298a06863f2a4b642de7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bb2e56382b62f061396641faab973860c0096d79a2292707d28d96e383df0c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8befdc711e368b049668f0e32ec0659eeafdcb7269a293f25ba2e23f08b54d30"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c969e982f7cad560d81656669e2502b90c6d3f8771258a8eecbf4740b937bf"
    sha256 cellar: :any_skip_relocation, ventura:       "03e9f52e34e00c905e4aaec764ada5c40469ac8ca0e559f8c9f5c54c429b8446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8d35e5944b185a5e504555324552fc5f2af90e9d81ac50c05866a536ed38261"
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
