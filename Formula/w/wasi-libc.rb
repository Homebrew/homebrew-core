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
    url "https://github.com/WebAssembly/wasi-libc/archive/refs/tags/wasi-sdk-32.tar.gz"
    sha256 "ea9827495c0f35bca3b3d0a953e854cac112c43bea3196b5a4f7f8fc4704b9a4"

    resource "WASI" do
      # Check the commit hash of `tools/wasi-headers/WASI` from the commit of the tag above.
      url "https://github.com/WebAssembly/WASI/archive/59cbe140561db52fc505555e859de884e0ee7f00.tar.gz"
      sha256 "fc78b28c2c06b64e0233544a65736fc5c515c5520365d6cf821408eadedaf367"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b24835e1e541ddb1cf6688880146174263d79b4e47e29c95bd130a998668bd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b24835e1e541ddb1cf6688880146174263d79b4e47e29c95bd130a998668bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b24835e1e541ddb1cf6688880146174263d79b4e47e29c95bd130a998668bd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b24835e1e541ddb1cf6688880146174263d79b4e47e29c95bd130a998668bd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f2cb6ddd72ace0e1fd9f2ffa5e66e285b961805636296ee9286bc8811ddde8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f2cb6ddd72ace0e1fd9f2ffa5e66e285b961805636296ee9286bc8811ddde8"
  end

  depends_on "cmake" => :build
  depends_on "lld" => [:build, :test]
  depends_on "llvm" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "wasm-micro-runtime" => :test

  fails_with :gcc do
    cause "requires Clang, see https://github.com/WebAssembly/wasi-libc/blob/main/README.md#building-from-source"
  end

  def install
    resource("WASI").stage buildpath/"tools/wasi-headers/WASI" if build.stable?

    # We don't want to use superenv here, since we are targeting WASM.
    ENV.remove_cc_etc
    ENV.remove "PATH", Superenv.shims_path
    ENV.prepend_path "PATH", Formula["lld"].opt_bin

    llvm_bin = Formula["llvm"].opt_bin
    clang = llvm_bin/"clang"
    clang_resource_dir = Pathname.new(Utils.safe_popen_read(clang, "--print-resource-dir").chomp)
    inreplace "CMakeLists.txt", "add_compile_options(--target=${TARGET_TRIPLE})",
                               "add_compile_options(--target=${TARGET_TRIPLE} -resource-dir=#{clang_resource_dir})"

    cmake_args = %W[
      -DCMAKE_AR=#{llvm_bin}/llvm-ar
      -DCMAKE_C_COMPILER=#{clang}
      -DCMAKE_INSTALL_PREFIX=#{share}/wasi-sysroot
      -DCMAKE_LINK_DEPENDS_USE_LINKER=FALSE
      -DCMAKE_NM=#{llvm_bin}/llvm-nm
      -DCMAKE_RANLIB=#{llvm_bin}/llvm-ranlib
      -DCHECK_SYMBOLS=ON
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

    targets.each do |target|
      build_dir = "build-#{target}"
      system "cmake", "-S", ".", "-B", build_dir, "-G", "Ninja", *cmake_args, "-DTARGET_TRIPLE=#{target}"
      system "cmake", "--build", build_dir
      system "cmake", "--install", build_dir
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
    builtins_dir = testpath/"lib/wasm32-unknown-wasi"
    resource("builtins").stage builtins_dir
    builtins_dir.install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasi --sysroot=#{share}/wasi-sysroot]
    system clang, *wasm_args, "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("iwasm #{testpath}/test")
  end
end
