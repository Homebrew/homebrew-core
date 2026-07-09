class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.26.tar.gz"
  sha256 "1bdcf5a3391ba26b1858349363643be4826bd5475805d90c3b4be84dae6604d7"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80c59b84c1fbc4490478d70e47f30befe06878eaaf22636576ac76897dffa9d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e38587ea2708ed7baa7ec28ff2047ce835851564f9e3122daf82a2ba942d15b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8639894685dd1e637b5b2fae305c02c204e2220d186de6d5af4396f4da488d55"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc0b7ab67af7f065c382e0838b982de3093103a155c1784681689e02469bc62c"
    sha256 cellar: :any,                 arm64_linux:   "77802482bb5b30a4508f513122d3155ad481944eb4f8f74fbfb7c04fa10b215b"
    sha256 cellar: :any,                 x86_64_linux:  "4b489c682e003b9ee87969f30afa9561adef2e1f07766fa534dc0ce8536b03fa"
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
