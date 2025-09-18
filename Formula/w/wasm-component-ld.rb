class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.17.tar.gz"
  sha256 "4061235a7caeb76922b6749ab75a2122a97ab65d7a48ef9e8ced28aa2bea69a7"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d03d6c0235fb0d6970a178ef0e89e32edf1d1d7d0c442b85a04fe884335ba4e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548858ba67b0dfb5676e298f842d694d02ec0a0898d75615a8afbec2ad1582ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68cdd1c1f241021f7e209cc19c00ff2a31cb18bc30c6687f799064b6a786056e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95ae30cf910ea80e93e7ee4319c1350af4b62330a47b9fdf4da23837bd7430c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "937ffaf65d1a5cb94aa4b318ec40cb25068bbcceb16e477431e66bae1a683368"
    sha256 cellar: :any_skip_relocation, ventura:       "35688822e716eb9acafe3290fe2aa72af8fb118a32ea62e34006600c782342cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bb5bdad6871f21b4b8d774a915b6c1cde3ad9ca0c9ec93e3a4912562c8a6700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06ac01ac0bad73fc83d19a75ccd604283e417d395b3f4b84b802a976f048a55a"
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
