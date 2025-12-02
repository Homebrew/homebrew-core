class WasiLibc < Formula
  desc "Libc implementation for WebAssembly"
  homepage "https://wasi.dev"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]
  head "https://github.com/WebAssembly/wasi-libc.git", branch: "main"

  stable do
    url "https://github.com/WebAssembly/wasi-libc/archive/refs/tags/wasi-sdk-28.tar.gz"
    sha256 "6f0b2e533ba09617c1f65496e5537806e1a7b0a34d4939f7dbb659ff30857b38"

    resource "WASI" do
      # Check the commit hash of `tools/wasi-headers/WASI` from the commit of the tag above.
      url "https://github.com/WebAssembly/WASI/archive/59cbe140561db52fc505555e859de884e0ee7f00.tar.gz"
      sha256 "fc78b28c2c06b64e0233544a65736fc5c515c5520365d6cf821408eadedaf367"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a529c0735dbb8a0650b31e03540ce34aa2821efba92b1b032e15e47a662fe5d9"
  end

  depends_on "llvm" => [:build, :test]
  depends_on "lld" => :test
  depends_on "wasm-micro-runtime" => :test

  # Needs clang
  fails_with :gcc

  def install
    resource("WASI").stage buildpath/"tools/wasi-headers/WASI" if build.stable?

    # We don't want to use superenv here, since we are targeting WASM.
    ENV.remove_cc_etc
    ENV.remove "PATH", Superenv.shims_path

    make_args = [
      "CC=#{Formula["llvm"].opt_bin}/clang",
      "AR=#{Formula["llvm"].opt_bin}/llvm-ar --format=gnu",
      "NM=#{Formula["llvm"].opt_bin}/llvm-nm",
      "INSTALL_DIR=#{share}/wasi-sysroot",
    ]

    # See targets at:
    # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/CMakeLists.txt#L14-L15
    targets = %w[
      wasm32-wasi
      wasm32-wasip1
      wasm32-wasip2
      wasm32-wasip1-threads
      wasm32-wasi-threads
    ]

    # See target flags at:
    # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/cmake/wasi-sdk-sysroot.cmake#L117-L135
    target_flags = Hash.new { |h, k| h[k] = [] }
    targets.each { |target| target_flags[target] << "THREAD_MODEL=posix" if target.end_with?("-threads") }
    target_flags["wasm32-wasip2"] << "WASI_SNAPSHOT=p2"

    targets.each do |target|
      system "make", *make_args, "TARGET_TRIPLE=#{target}", "CHECK_SYMBOLS=yes", "install", *target_flags[target]
    end
  end

  test do
    # TODO: We should probably build this from source and package it as a formula.
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
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasi"
    (testpath/"lib/wasm32-unknown-wasi").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasi --sysroot=#{share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("iwasm #{testpath}/test")
  end
end
