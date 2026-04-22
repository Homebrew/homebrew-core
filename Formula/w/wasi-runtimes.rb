class WasiRuntimes < Formula
  desc "Compiler-RT and libc++ runtimes for WASI"
  homepage "https://wasi.dev"
  # TODO: Check if any build changes are needed after https://github.com/WebAssembly/wasi-sdk/pull/585
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.4/llvm-project-22.1.4.src.tar.xz"
  sha256 "3e68c90dda630c27d41d201e37b8bbf5222e39b273dec5ca880709c69e0a07d4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  livecheck do
    formula "llvm"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9c21b532286523ef7cd3241075d0f650218db0ea1ed72239859a4b93d0f954b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd448936807b2ef4183e6b8cd59619e44a1d8ca4bcaa0fe14737fa8c0849ddfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb25aa32c71de7605c57807812f21b66ca8984ce7d977e0dea68099b93d9b72"
    sha256 cellar: :any_skip_relocation, sonoma:        "da473a50efe84ccc8539aa5d23fce144680e60e45800bc18858a521851be0ce8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "332172b6b881219623722ee6a74e0646b01e111d1e347dde98790a85f24ef6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942c4df3c1f3cb28965f131051aedd42ada8f38ca87ee25f9985c173cb206978"
  end

  depends_on "cmake" => :build
  depends_on "wasi-libc" => [:build, :test]
  depends_on "lld" => :test
  depends_on "wasm-component-ld" => :test
  depends_on "wasmtime" => :test
  depends_on "llvm"

  def wasi_sdk_targets
    # See targets at: https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-30/CMakeLists.txt#L14-L15
    %w[
      wasm32-wasi
      wasm32-wasip1
      wasm32-wasip2
      wasm32-wasip1-threads
      wasm32-wasi-threads
    ]
  end

  def install
    # Avoid build failure when wasi-runtimes config files are already installed
    ENV["CLANG_NO_DEFAULT_CONFIG"] = "1"

    llvm = Formula["llvm"]
    wasi_libc = Formula["wasi-libc"]
    wasi_resource_dir = pkgshare
    wasi_sdk_cpu_cflags = "-mcpu=lime1"

    # Compiler flags taken from following tag, excluding unused CMAKE_MODULE_PATH
    # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-30/cmake/wasi-sdk-sysroot.cmake#L40-L57
    default_cmake_args = %W[
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
      -DCMAKE_C_LINKER_DEPFILE_SUPPORTED=OFF
      -DCMAKE_CXX_LINKER_DEPFILE_SUPPORTED=OFF
    ]
    # Add some extra Homebrew-specific flags
    default_cmake_args += %W[
      -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY
      -DCMAKE_FIND_FRAMEWORK=NEVER
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DCMAKE_PROJECT_TOP_LEVEL_INCLUDES=#{HOMEBREW_LIBRARY_PATH}/cmake/trap_fetchcontent_provider.cmake
    ]
    # Compiler flags taken from following commit (HEAD at time of update):
    # https://github.com/WebAssembly/wasi-sdk/blob/a64d51d14378e306add001fad180d5733df1491c/cmake/wasi-sdk-sysroot.cmake#L75-L95
    compiler_rt_args = %W[
      -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON
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
      -DCMAKE_ASM_FLAGS=#{wasi_sdk_cpu_cflags}
      -DCMAKE_INSTALL_PREFIX=#{wasi_resource_dir}
    ]
    ENV.append_to_cflags wasi_sdk_cpu_cflags
    ENV.append_to_cflags "-fdebug-prefix-map=#{buildpath}=wasisdk://v#{wasi_libc.version}"

    %w[
      wasm32-wasip1
      wasm32-wasip1-threads
    ].each do |target|
      build_dir = "build-compiler-rt-#{target}"
      target_args = %W[
        -DCMAKE_C_COMPILER_TARGET=#{target}
        -DCMAKE_CXX_COMPILER_TARGET=#{target}
        -DCMAKE_ASM_COMPILER_TARGET=#{target}
      ]
      # Don't use `std_cmake_args`. It sets things like `CMAKE_OSX_SYSROOT`.
      system "cmake", "-S", "compiler-rt", "-B", build_dir, *default_cmake_args, *compiler_rt_args, *target_args
      system "cmake", "--build", build_dir
      system "cmake", "--install", build_dir
    end
    (wasi_resource_dir/"lib").install_symlink "wasm32-unknown-wasip1" => "wasm32-unknown-wasi"
    (wasi_resource_dir/"lib").install_symlink "wasm32-unknown-wasip1" => "wasm32-unknown-wasip2"
    (wasi_resource_dir/"lib").install_symlink "wasm32-unknown-wasip1-threads" => "wasm32-unknown-wasi-threads"

    clang_resource_dir = Utils.safe_popen_read(llvm.opt_bin/"clang", "-print-resource-dir").chomp
    clang_resource_dir.sub! llvm.prefix.realpath, llvm.opt_prefix
    clang_resource_dir = Pathname.new(clang_resource_dir)

    clang_resource_include_dir = clang_resource_dir/"include"
    clang_resource_include_dir.find do |pn|
      next unless pn.file?

      relative_path = pn.relative_path_from(clang_resource_dir)
      target = wasi_resource_dir/relative_path
      next if target.exist?

      target.parent.mkpath
      ln_s pn, target
    end

    wasi_sdk_targets.each do |target|
      # Configuration taken from:
      # https://github.com/WebAssembly/wasi-sdk/blob/wasi-sdk-30/cmake/wasi-sdk-sysroot.cmake#L209-L215
      pic = target.end_with?("-threads") ? "OFF" : "ON"
      target_flags = target.end_with?("-threads") ? ["-pthread"] : []

      extra_flags = target_flags + %W[
        --target=#{target}
        --sysroot=#{wasi_libc.opt_share}/wasi-sysroot
        -resource-dir=#{wasi_resource_dir}
      ]
      extra_cflags = (ENV.cflags&.split.to_a + extra_flags).join(" ")
      extra_cxxflags = (ENV.cxxflags&.split.to_a + extra_flags).join(" ")

      # FIXME: Upstream sets the equivalent of
      #   `-DLIBCXX_ENABLE_SHARED=#{pic}`
      #   `-DLIBCXXABI_ENABLE_SHARED=#{pic}`
      # but the build fails with linking errors.
      # See: https://github.com/WebAssembly/wasi-sdk/blob/a64d51d14378e306add001fad180d5733df1491c/cmake/wasi-sdk-sysroot.cmake#L255-L305
      # NOTE: disabled LIBCXX_HAS_MUSL_LIBC for LLVM 22 based on https://github.com/WebAssembly/wasi-sdk/pull/585
      target_cmake_args = %W[
        -DCMAKE_INSTALL_INCLUDEDIR=#{share}/wasi-sysroot/include/#{target}
        -DCMAKE_STAGING_PREFIX=#{share}/wasi-sysroot
        -DCMAKE_POSITION_INDEPENDENT_CODE=#{pic}
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
        -DLIBCXX_CXX_ABI=libcxxabi
        -DLIBCXX_CXX_ABI_INCLUDE_PATHS=#{buildpath}/libcxxabi/include
        -DLIBCXX_HAS_MUSL_LIBC:BOOL=OFF
        -DLIBCXX_ABI_VERSION=2
        -DLIBCXXABI_ENABLE_EXCEPTIONS:BOOL=OFF
        -DLIBCXXABI_ENABLE_SHARED:BOOL=OFF
        -DLIBCXXABI_SILENT_TERMINATE:BOOL=ON
        -DLIBCXXABI_ENABLE_THREADS:BOOL=ON
        -DLIBCXXABI_HAS_PTHREAD_API:BOOL=ON
        -DLIBCXXABI_HAS_EXTERNAL_THREAD_API:BOOL=OFF
        -DLIBCXXABI_BUILD_EXTERNAL_THREAD_LIBRARY:BOOL=OFF
        -DLIBCXXABI_HAS_WIN32_THREAD_API:BOOL=OFF
        -DLIBCXXABI_ENABLE_PIC:BOOL=#{pic}
        -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=OFF
        -DUNIX:BOOL=ON
        -DCMAKE_C_FLAGS=#{extra_cflags}
        -DCMAKE_ASM_FLAGS=#{extra_cflags}
        -DCMAKE_CXX_FLAGS=#{extra_cxxflags}
        -DLIBCXX_LIBDIR_SUFFIX=/#{target}
        -DLIBCXXABI_LIBDIR_SUFFIX=/#{target}
        -DLIBCXX_INCLUDE_TESTS=OFF
        -DLIBCXX_INCLUDE_BENCHMARKS=OFF
        -DLLVM_ENABLE_RUNTIMES:STRING=libcxx;libcxxabi
      ]

      # Don't use `std_cmake_args`. It sets things like `CMAKE_OSX_SYSROOT`.
      system "cmake", "-S", "runtimes", "-B", "runtimes-#{target}", *default_cmake_args, *target_cmake_args
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
    wasi_sdk_targets.each do |target|
      system clang, "--target=#{target}", "-v", "test.c", "-o", "test-#{target}"
      wasmtime_flags = if target.end_with?("-threads")
        "-W threads=y -W shared-memory=y -S threads=y"
      else
        ""
      end
      assert_equal "the answer is 42",
                   shell_output("wasmtime run #{wasmtime_flags} #{testpath}/test-#{target}").strip

      pthread_flags = target.end_with?("-threads") ? ["-pthread"] : []
      system "#{clang}++", "--target=#{target}", "-v", "test.cc", "-o", "test-cxx-#{target}", *pthread_flags
      assert_equal "hello from C++ main with cout!",
                   shell_output("wasmtime run #{wasmtime_flags} #{testpath}/test-cxx-#{target}").chomp
    end
  end
end
