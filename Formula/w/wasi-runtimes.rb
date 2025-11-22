class WasiRuntimes < Formula
  desc "Compiler-RT and libc++ runtimes for WASI"
  homepage "https://wasi.dev"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.6/llvm-project-21.1.6.src.tar.xz"
  sha256 "ae67086eb04bed7ca11ab880349b5f1ab6f50e1b88cda376eaf8a845b935762b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "147473d6fa0e6956012b23495c5e08ff28309ea6e29a1659eef881cf2d903d38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae316a91b6ecd76eee4176da6f4205c52b12d2f3a5f46478cf9c0772692c054a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724d8353867e064a930dfa9b7dac0b3336f4627e05beef3f0838625b75a6df04"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd3e2fad9976aa03bea743a8dd29d29460d6d3cd4113e12cd78d3e83aaa7c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4695a9dfe7f7ca771c2719d7f178ff57d097c7d06f4c97f225d48e9f0e0f78de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1a934b9308d1db75d6da284157b9cd508f0bf7abc7ad063be347520d9ce93d3"
  end

  depends_on "cmake" => :build
  depends_on "wasi-libc" => [:build, :test]
  depends_on "lld" => :test
  depends_on "wasm-component-ld" => :test
  depends_on "wasmtime" => :test
  depends_on "llvm"

  def targets
    # See targets at:
    # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/CMakeLists.txt#L14-L15
    %w[
      wasm32-wasi
      wasm32-wasip1
      wasm32-wasip2
      wasm32-wasip1-threads
      wasm32-wasi-threads
    ]
  end

  def install
    wasi_libc = Formula["wasi-libc"]
    llvm = Formula["llvm"]
    # Compiler flags taken from:
    # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/cmake/wasi-sdk-sysroot.cmake#L37-L50
    common_cmake_args = %W[
      -DCMAKE_SYSTEM_NAME=WASI
      -DCMAKE_SYSTEM_VERSION=1
      -DCMAKE_SYSTEM_PROCESSOR=wasm32
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_AR=#{llvm.opt_bin}/llvm-ar
      -DCMAKE_C_COMPILER=#{llvm.opt_bin}/clang
      -DCMAKE_CXX_COMPILER=#{llvm.opt_bin}/clang++
      -DCMAKE_C_COMPILER_WORKS=ON
      -DCMAKE_CXX_COMPILER_WORKS=ON
      -DCMAKE_SYSROOT=#{wasi_libc.opt_share}/wasi-sysroot
      -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
      -DCMAKE_FIND_FRAMEWORK=NEVER
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=#{HOMEBREW_LIBRARY_PATH}/cmake/trap_fetchcontent_provider.cmake
    ]
    # Compiler flags taken from:
    # https://github.com/WebAssembly/wasi-sdk/blob/53551e59438641b25e63bf304869ab4da6d512d9/cmake/wasi-sdk-sysroot.cmake#L71-L88
    compiler_rt_args = %W[
      -DCMAKE_INSTALL_PREFIX=#{pkgshare}
      -DCOMPILER_RT_BAREMETAL_BUILD=ON
      -DCOMPILER_RT_BUILD_XRAY=OFF
      -DCOMPILER_RT_INCLUDE_TESTS=OFF
      -DCOMPILER_RT_HAS_FPIC_FLAG=OFF
      -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON
      -DCOMPILER_RT_BUILD_SANITIZERS=OFF
      -DCOMPILER_RT_BUILD_XRAY=OFF
      -DCOMPILER_RT_BUILD_LIBFUZZER=OFF
      -DCOMPILER_RT_BUILD_PROFILE=OFF
      -DCOMPILER_RT_BUILD_CTX_PROFILE=OFF
      -DCOMPILER_RT_BUILD_MEMPROF=OFF
      -DCOMPILER_RT_BUILD_ORC=OFF
      -DCOMPILER_RT_BUILD_GWP_ASAN=OFF
      -DCMAKE_C_COMPILER_TARGET=wasm32-wasi
      -DCOMPILER_RT_OS_DIR=wasi
    ]
    ENV.append_to_cflags "-fdebug-prefix-map=#{buildpath}=wasisdk://v#{wasi_libc.version}"
    ENV.append_to_cflags "-mcpu=lime1"
    # Don't use `std_cmake_args`. It sets things like `CMAKE_OSX_SYSROOT`.
    system "cmake", "-S", "compiler-rt", "-B", "build-compiler-rt", *compiler_rt_args, *common_cmake_args
    system "cmake", "--build", "build-compiler-rt"
    system "cmake", "--install", "build-compiler-rt"
    (pkgshare/"lib").install_symlink "wasi" => "wasip1"
    (pkgshare/"lib").install_symlink "wasi" => "wasip2"

    clang_resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    clang_resource_dir.sub! llvm.prefix.realpath, llvm.opt_prefix
    clang_resource_dir = Pathname.new(clang_resource_dir)

    clang_resource_include_dir = clang_resource_dir/"include"
    clang_resource_include_dir.find do |pn|
      next unless pn.file?

      relative_path = pn.relative_path_from(clang_resource_dir)
      target = pkgshare/relative_path
      next if target.exist?

      target.parent.mkpath
      ln_s pn, target
    end

    target_configuration = Hash.new { |h, k| h[k] = {} }

    targets.each do |target|
      # Configuration taken from:
      # https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/cmake/wasi-sdk-sysroot.cmake#L227-L271
      configuration = target_configuration[target]
      configuration[:pic] = target.end_with?("-threads") ? "OFF" : "ON"
      configuration[:flags] = target.end_with?("-threads") ? ["-pthread"] : []

      cflags = ENV.cflags&.split || []
      cxxflags = ENV.cxxflags&.split || []

      extra_flags = configuration.fetch(:flags)
      extra_flags += %W[
        --target=#{target}
        --sysroot=#{wasi_libc.opt_share}/wasi-sysroot
        -resource-dir=#{pkgshare}
      ]
      cflags += extra_flags
      cxxflags += extra_flags

      # FIXME: Upstream sets the equivalent of
      #   `-DLIBCXX_ENABLE_SHARED=#{configuration.fetch(:pic)}`
      #   `-DLIBCXXABI_ENABLE_SHARED=#{configuration.fetch(:pic)}`
      # but the build fails with linking errors.
      # See: https://github.com/WebAssembly/wasi-sdk/blob/5e04cd81eb749edb5642537d150ab1ab7aedabe9/cmake/wasi-sdk-sysroot.cmake#L227-L271
      target_cmake_args = %W[
        -DCMAKE_INSTALL_INCLUDEDIR=#{share}/wasi-sysroot/include/#{target}
        -DCMAKE_STAGING_PREFIX=#{share}/wasi-sysroot
        -DCMAKE_POSITION_INDEPENDENT_CODE=#{configuration.fetch(:pic)}
        -DCXX_SUPPORTS_CXX11=ON
        -DLIBCXX_ENABLE_THREADS:BOOL=ON
        -DLIBCXX_HAS_PTHREAD_API:BOOL=ON
        -DLIBCXX_HAS_EXTERNAL_THREAD_API:BOOL=OFF
        -DLIBCXX_BUILD_EXTERNAL_THREAD_LIBRARY:BOOL=OFF
        -DLIBCXX_HAS_WIN32_THREAD_API:BOOL=OFF
        -DLLVM_COMPILER_CHECKED=ON
        -DLIBCXX_ENABLE_SHARED:BOOL=OFF
        -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY:BOOL=OFF
        -DLIBCXX_ENABLE_EXCEPTIONS:BOOL=OFF
        -DLIBCXX_ENABLE_FILESYSTEM:BOOL=ON
        -DLIBCXX_ENABLE_ABI_LINKER_SCRIPT:BOOL=OFF
        -DLIBCXX_USE_COMPILER_RT:BOOL=ON
        -DLIBCXXABI_USE_COMPILER_RT:BOOL=ON
        -DLIBCXX_CXX_ABI=libcxxabi
        -DLIBCXX_CXX_ABI_INCLUDE_PATHS=#{buildpath}/libcxxabi/include
        -DLIBCXX_HAS_MUSL_LIBC:BOOL=ON
        -DLIBCXX_ABI_VERSION=2
        -DLIBCXXABI_ENABLE_EXCEPTIONS:BOOL=OFF
        -DLIBCXXABI_ENABLE_SHARED:BOOL=OFF
        -DLIBCXXABI_SILENT_TERMINATE:BOOL=ON
        -DLIBCXXABI_ENABLE_THREADS:BOOL=ON
        -DLIBCXXABI_HAS_PTHREAD_API:BOOL=ON
        -DLIBCXXABI_HAS_EXTERNAL_THREAD_API:BOOL=OFF
        -DLIBCXXABI_BUILD_EXTERNAL_THREAD_LIBRARY:BOOL=OFF
        -DLIBCXXABI_HAS_WIN32_THREAD_API:BOOL=OFF
        -DLIBCXXABI_ENABLE_PIC:BOOL=#{configuration.fetch(:pic)}
        -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=OFF
        -DUNIX:BOOL=ON
        -DCMAKE_C_FLAGS=#{cflags.join(" ")}
        -DCMAKE_CXX_FLAGS=#{cxxflags.join(" ")}
        -DLIBCXX_LIBDIR_SUFFIX=/#{target}
        -DLIBCXXABI_LIBDIR_SUFFIX=/#{target}
        -DLIBCXX_INCLUDE_TESTS=OFF
        -DLIBCXX_INCLUDE_BENCHMARKS=OFF
        -DLLVM_ENABLE_RUNTIMES:STRING=libcxx;libcxxabi
      ]

      # Don't use `std_cmake_args`. It sets things like `CMAKE_OSX_SYSROOT`.
      system "cmake", "-S", "runtimes", "-B", "runtimes-#{target}", *target_cmake_args, *common_cmake_args
      system "cmake", "--build", "runtimes-#{target}"
      system "cmake", "--install", "runtimes-#{target}"

      triple = Utils.safe_popen_read(llvm.opt_bin/"clang", "--target=#{target}", "--print-target-triple").chomp
      config_file = "#{triple}.cfg"

      (buildpath/config_file).write <<~CONFIG
        --sysroot=#{HOMEBREW_PREFIX}/share/wasi-sysroot
        -resource-dir=#{HOMEBREW_PREFIX}/share/wasi-runtimes
      CONFIG

      (etc/"clang").install config_file
    end
    (share/"wasi-sysroot/include/c++/v1").mkpath
    touch share/"wasi-sysroot/include/c++/v1/.keepme"
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
    (testpath/"test.cc").write <<~CPP
      #include <iostream>

      int main() {
          std::cout << "hello from C++ main with cout!" << std::endl;
          return 0;
      }
    CPP

    clang = Formula["llvm"].opt_bin/"clang"
    targets.each do |target|
      system clang, "--target=#{target}", "-v", "test.c", "-o", "test-#{target}"
      assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test-#{target}")

      pthread_flags = target.end_with?("-threads") ? ["-pthread"] : []
      system "#{clang}++", "--target=#{target}", "-v", "test.cc", "-o", "test-cxx-#{target}", *pthread_flags
      assert_equal "hello from C++ main with cout!", shell_output("wasmtime #{testpath}/test-cxx-#{target}").chomp
    end
  end
end
