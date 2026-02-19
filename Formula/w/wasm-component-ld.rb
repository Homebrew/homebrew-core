class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.20.tar.gz"
  sha256 "1cae6e3e2dde201fa29aa7c1afae65c3955894a7a3ed9093d911464661146e08"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6712a328692965dfd68e28c679a63e2447a8f22ebd0a8edefb1191a07e2adbd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3995070611f9bce9c1c7209d0f38165817eb08418845bf3bd6ffec6f255cb93d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "909a42600129905a4f4782147fe1554d44db1f2b67e4df50571a5c1c76a27633"
    sha256 cellar: :any_skip_relocation, sonoma:        "c765e31c7de67d0ad1caa02a3f7ce0a54ef6cd48d00b73dabc48725031fa4f8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ae6bd628796a1594fe8bba20ac10012f90d0e8c4b060c4c1147a55e962c0ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ae282a3c72c7cd7664d2f3d92b1e83d6f71431c98f676689a34cb375a6dc68"
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
