class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.19.tar.gz"
  sha256 "27740152c704b8a3ada995188b5fd37ca5053d40c83d00f1a22d05ed1bed6a98"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "735232db202b591824c3fb763e5dddbe1c388df00e4d54800200658cc4058e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b882449017ca923051f761ea634631106f6bddedccfc300897befd65ae7cb81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef3f5afb6ab73dac3553c1008fa22e6c8e0dc53411da7f9b74934d7024dfd22c"
    sha256 cellar: :any_skip_relocation, sonoma:        "be8d1a64ec33900b1e3b86e0684f10ef0e05a6e77572140ace135fd98a545d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e94c016b3eaf69f78c0f10eefc403a4d53c0014612a9fe9c219cb9d7fc5ab8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52cd87e216af40afdbcd47103b064d003b48d9ac7e205077de6f8fcea383fcb6"
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
