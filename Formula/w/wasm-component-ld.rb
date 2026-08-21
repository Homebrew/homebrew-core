class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.30.tar.gz"
  sha256 "d5e9b986da0807b3059c32cf56690933b93ef910226ebb08ceb434397446fd0f"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa08b67f61302c1341db1ce19fed71aec3e23c3c8f2438449507c086733c8ef8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df64a3ebcf842733192d4df93f03f4715ec8b2119487016a04b9e84d01f80dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1968db74abcccf0369442038fbe516afdd148ceee96e929990e08fa9c691dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "48fcfe5bea3cc267a0fc7ac60c496a41ca67a1247a58557cfea1d423cb5186f0"
    sha256 cellar: :any,                 arm64_linux:   "6a49cabf8f30b1411c41626e10ef4a0a78115fb0d5c7034441d36c48d3e9ea66"
    sha256 cellar: :any,                 x86_64_linux:  "2de5fe408456450bd9bf8a16e4954c7ee8389dfdba3adb0d3327d69ca7d4442f"
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
