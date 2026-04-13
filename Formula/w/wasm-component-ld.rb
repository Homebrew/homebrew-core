class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.22.tar.gz"
  sha256 "152c53c2981665ff73fc97a9906726d5253afa26ad1ae58a3d02ba702e84dcb3"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257594d7942a8d6b32ce30fc4c3ef5765212d6dcb5c652db17f4fa9c079c003a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ebe7160a5657e9d8ff178f933ea9c1276b7854ab8b383eaf2ffbfa18b75fd22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ef5e7aa0514ef6098f7ae0491f9917b89c57cbc541cfd8ac02220150c54fc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "812b82029c2fe43def6268941f8a8b000a684b9baaa69c4dd6c9fae63124d6f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bab390550d9b96f2eb9147b4a3b8e0d605d6fe4cdfe5cfced72be90cef0430f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb57d2eb935eac27efe877079649b9f8668dbb5bd587cc32db85456e1abe34f9"
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
