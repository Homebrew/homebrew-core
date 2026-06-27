class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.25.tar.gz"
  sha256 "852f2b7a91c92b3f7442e2b839fce21ca235798e4e9fe4cfffa70c2f7dc5c511"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e5e10ac5847ecd8891202f2088f18baf08207479608316a34a32eb1fef04110"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a91c1f29895be0682ebbfee6610b922584046685ea070a5268af3d44a9b407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdc6348bdd22c1ecf5213a62c4cc1f98a451dfbecc6c3281ffb880d0d450618d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc135f33ee83e040375c831c6ab86b96bd1d34724b3db7086b6514c195ac1687"
    sha256 cellar: :any,                 arm64_linux:   "297e6524d48a116183613620d0667866e140e268881726f89f98d3fc6da20ab8"
    sha256 cellar: :any,                 x86_64_linux:  "cff5846677b9e1c374dd772d8f34fe06dd263d87878d2adcc8ec92068fdcf1bf"
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
