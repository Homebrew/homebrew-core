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
    url "https://github.com/WebAssembly/wasi-libc/archive/refs/tags/wasi-sdk-34.tar.gz"
    sha256 "21bc47f96cf0eb535e532697dce4cdfdbc91f59223bdc00d8495d191888c5fe8"

    resource "WASI" do
      # Check the commit hash of `tools/wasi-headers/WASI` from the commit of the tag above.
      url "https://github.com/WebAssembly/WASI/archive/59cbe140561db52fc505555e859de884e0ee7f00.tar.gz"
      version "59cbe140561db52fc505555e859de884e0ee7f00"
      sha256 "fc78b28c2c06b64e0233544a65736fc5c515c5520365d6cf821408eadedaf367"

      livecheck do
        url "https://api.github.com/repos/WebAssembly/wasi-libc/contents/tools/wasi-headers/WASI?ref=wasi-sdk-#{LATEST_VERSION}"
        strategy :json do |json|
          json["sha"]
        end
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1b7d1b3f8492a5982a0d26655ba75afbed1b823abad3adc794f2873537b0911f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5e53927e23f5981de6b3efafffc42dc6656f8b19f2c53013474a0a97edb6528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5e53927e23f5981de6b3efafffc42dc6656f8b19f2c53013474a0a97edb6528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b5e53927e23f5981de6b3efafffc42dc6656f8b19f2c53013474a0a97edb6528"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8366085c21d11ba0f45a84cfce10038c733538736a259c6de5f9058d46662989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8366085c21d11ba0f45a84cfce10038c733538736a259c6de5f9058d46662989"
  end

  depends_on "cmake" => :build
  depends_on "lld" => [:build, :test]
  depends_on "llvm" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "wasm-component-ld" => [:build, :test]
  depends_on "wasm-tools" => :build
  depends_on "wasmtime" => :test

  fails_with :gcc do
    cause "requires Clang, see https://github.com/WebAssembly/wasi-libc/blob/main/README.md#building-from-source"
  end

  # wasi-libc needs an existing libclang_rt. Ideally we would use the one we
  # built (wasi-runtimes); however, there is a dependency loop.
  resource "builtins" do
    url "https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-34-rc.1/libclang_rt-34.0-rc.1.tar.gz"
    sha256 "84da92d09e34bac7d39eb7f8075697b4f00bbccd0cfb6ce9654565ad6a7e2dfe"

    livecheck do
      url "https://raw.githubusercontent.com/WebAssembly/wasi-libc/refs/tags/wasi-sdk-#{LATEST_VERSION}/cmake/builtins.cmake"
      regex(/URL .*?libclang_rt[._-]v?(\d+(?:\.\d+)*(-rc\.\d+)?)\.t/i)
    end
  end

  # needs to download resources in the `test` block
  # FIXME: `brew` should know to download test resources before sandboxing.
  allow_network_access! :test

  def wasi_sdk_targets
    # See targets at: https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-34/CMakeLists.txt#L14
    %w[
      wasm32-wasip1
      wasm32-wasip2
      wasm32-wasip3
      wasm32-wasip1-threads
    ]
  end

  def wasi_sysroot = share/"wasi-sysroot"

  # The following build is based on upstream wasi-sdk build:
  # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-34/cmake/wasi-sdk-sysroot.cmake#L167-L254
  # NOTE: we currently disable experimental coop threads, LTO build and dual EH/no-EH build.
  def install
    resource("WASI").stage buildpath/"tools/wasi-headers/WASI" if build.stable?
    resource("builtins").stage buildpath/"wasi-resource-dir/lib"

    # We don't want to use superenv here, since we are targeting WASM.
    ENV.remove_cc_etc
    ENV.remove "PATH", Superenv.shims_path
    # Avoid build failure when wasi-runtimes config files are already installed
    ENV["CLANG_NO_DEFAULT_CONFIG"] = "1"

    # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-34/cmake/wasi-sdk-sysroot.cmake#L58-L76
    llvm_bin = formula_opt_bin("llvm")
    default_cmake_args = %W[
      -DCMAKE_SYSTEM_NAME=WASI
      -DCMAKE_SYSTEM_VERSION=1
      -DCMAKE_SYSTEM_PROCESSOR=wasm32
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_AR=#{llvm_bin}/llvm-ar
      -DCMAKE_C_COMPILER=#{llvm_bin}/clang
      -DCMAKE_CXX_COMPILER=#{llvm_bin}/clang++
      -DCMAKE_C_COMPILER_WORKS=ON
      -DCMAKE_CXX_COMPILER_WORKS=ON
      -DCMAKE_C_LINKER_DEPFILE_SUPPORTED=OFF
      -DCMAKE_CXX_LINKER_DEPFILE_SUPPORTED=OFF
    ]

    wasi_sdk_cpu_cflags = "-mcpu=lime1"
    # Replacing `-fdebug-prefix-map=${CMAKE_CURRENT_SOURCE_DIR}=wasisdk://v${wasi_sdk_version}`
    # with modern `-ffile-prefix-map=#{buildpath}=.` which we use in superenv.
    directory_cflags = "-ffile-prefix-map=#{buildpath}=."

    wasi_sdk_targets.each do |target|
      extra_cflags_list = [wasi_sdk_cpu_cflags, directory_cflags]
      check_symbols = "ON"

      # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-34/cmake/wasi-sdk-sysroot.cmake#L176-L180
      # > Always enable `-fPIC` for the `wasm32-wasip2` and `wasm32-wasip3` targets.
      # > This makes `libc.a` more flexible and usable in dynamic linking situations.
      if target.match?(/p[23]/)
        extra_cflags_list << "-fPIC"
        check_symbols = "OFF" # however it changes symbols so cannot verify them
      end
      extra_cflags = extra_cflags_list.join(" ")

      triple = target.sub("wasm32-", "wasm32-unknown-")
      libcompiler_rt_a = buildpath/"wasi-resource-dir/lib/#{triple}/libclang_rt.builtins.a"

      # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-34/cmake/wasi-sdk-sysroot.cmake#L215-L227
      # Excluding `WASI_SDK_VERSION` as it adds another symbol so impacts `CHECK_SYMBOLS`
      build_dir = "wasi-libc-#{target}-build"
      cmake_args = default_cmake_args + %W[
        -DTARGET_TRIPLE=#{target}
        -DCMAKE_INSTALL_PREFIX=#{wasi_sysroot}
        -DCMAKE_C_FLAGS=#{extra_cflags}
        -DCMAKE_ASM_FLAGS=#{extra_cflags}
        -DBUILTINS_LIB=#{libcompiler_rt_a}
        -DUSE_WASM_COMPONENT_LD=OFF
        -DCMAKE_SYSROOT=#{wasi_sysroot}
      ]
      # Not used by wasi-sdk, but useful to verify as long as options don't impact symbols
      cmake_args << "-DCHECK_SYMBOLS=#{check_symbols}"

      system "cmake", "-S", ".", "-B", build_dir, "-G", "Ninja", *cmake_args
      system "cmake", "--build", build_dir
      system "cmake", "--install", build_dir
    end
  end

  test do
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
    resource("builtins").stage testpath/"lib"

    wasi_sdk_targets.each do |target|
      wasm_args = %W[--target=#{target} --sysroot=#{wasi_sysroot}]
      wasmtime_flags = "-W threads=y -W shared-memory=y" if target.end_with?("-threads")
      system clang, *wasm_args, "test.c", "-o", "test-#{target}", "-resource-dir=#{testpath}"
      assert_equal "the answer is 42", shell_output("wasmtime run #{wasmtime_flags} #{testpath}/test-#{target}")
    end
  end
end
