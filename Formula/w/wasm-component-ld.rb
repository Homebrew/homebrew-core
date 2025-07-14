class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.15.tar.gz"
  sha256 "d625ce7efba6b88fd0691d313681b660bb1c456945d812355936c7cd489912b1"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17e326a318cde70fc98e3e2a44d0fb84db3fc824be258eb2b64794aa3b9d5639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ad24ad7f196c7ec3eed6c0500ae70aa31e8c90463737e468f06164e4f8d7f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "883b7cc81f97350e726af4623c9ca32c25b8334d7f84c285073a3c6c69cfb2f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec2dfa735316204c130fd0da7fad44640fe2a0f8654304977791e9f1b31fd9f"
    sha256 cellar: :any_skip_relocation, ventura:       "f0fbf440eaeec7b4f916233dafea6c28956636070c7c3fa4e4949f90412125ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d409cc57606957146707dc72376cb63d5abb81ab8a81542565907df1288abd7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ff1b6e3a39f89bc15d9c0d710f55d422ab17dce8dbe737acad6bd4efdc92ef"
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
