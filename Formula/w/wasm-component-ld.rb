class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.21.tar.gz"
  sha256 "b87d9ad8bfee2676b000c2ec37e4e4129c28188f578cd03f2bf11651371c0812"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9abe52eaff447dc06faf8ddd2d86e2b411bbf38618fdd9310159043986818f13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2509d0eb89d2fb4ab00d18077cb6af58f556a6c07d92ef5c25e0562f3af250c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffdce2520954b78ed68d2267163efff3d35842750ecf6e3b12a270ac9ab57ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c0ddf010879b1adb0bfed53e7bca5211e508810e947f914cfc09b9c9c9cfa16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f5341a8ae6a07dcb0ed72a43c8668b101be1bae02192a5700b8146db465e414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff12b4bb0d0c3bfa8c603b92b373936b0fc10d51e7645285aaed539a080bdd0"
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
