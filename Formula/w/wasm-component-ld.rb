class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.13.tar.gz"
  sha256 "bd1f826cd4d0d47dba5fa55396c72bbab8b61f80b23a51a32b4b29e50ec172f8"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4625a98ad289db904f504b84a0a669be54038d0ec7cfaeced83059000880d1c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "955adfe1877b6a0e2b2b3dfd80bdcf3e5c12febc3da4f6b6542f4556e2e3c7d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff3de87611752b9c709f0da0ac4016f9ec8f90f7388d80078dbce027e8de0bf7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a658eb833d3206a390e57d6a6235112dadd6da832ae2af23605fec0fb9a70ac0"
    sha256 cellar: :any_skip_relocation, ventura:       "539305753eb9610cf57236d6d98072957eee03d7c238ae7b2825cf2e3228450f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5787094a06258ada03c8bf49f464ae6a8e69bddba0b0d92c02f7c88def5ccc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "732c31ceef2b2d4cfd129622854dd170733f4c5b58ae937eb9039dcc5ad2ffdc"
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
