class Redistimeseries < Formula
  desc "Time series data structure for Redis"
  homepage "https://github.com/RedisTimeSeries/RedisTimeSeries"
  url "https://github.com/RedisTimeSeries/RedisTimeSeries.git",
      tag:      "v8.6.0",
      revision: "05fd355db748676861dc4c17d19c8c1ca74c0154"
  license all_of: [
    "AGPL-3.0-only",
    "Apache-2.0", # deps/cpu_features
    "BSD-3-Clause", # deps/readies, deps/LibMR/deps/*
    "MIT", # deps/RedisModulesSDK, deps/minunit
    { any_of: [{ "Apache-2.0" => { with: "LLVM-exception" } }, "BSL-1.0"] }, # deps/dragonbox
    { any_of: ["Apache-2.0", "BSL-1.0"] }, # deps/fast_double_parser_c
  ]
  head "https://github.com/RedisTimeSeries/RedisTimeSeries.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "llvm@18" => :build
  depends_on "make" => :build
  depends_on "python@3.14" => :build

  depends_on "openssl@3"

  def install
    # Set up environment for macOS build
    llvm = Formula["llvm@18"]
    openssl = Formula["openssl@3"]

    # Add GNU tools to PATH (required by build system)
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", llvm.opt_bin

    # Set compiler flags for OpenSSL and LLVM
    ENV.append "CFLAGS", "-I#{openssl.opt_include}"
    ENV.append "CXXFLAGS", "-I#{openssl.opt_include}"
    ENV.append "CPPFLAGS", "-I#{openssl.opt_include}"
    ENV.append "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.append "CPPFLAGS", "-I#{llvm.opt_include}"
    ENV.append "LDFLAGS", "-L#{llvm.opt_lib}"

    # Build the module
    system "make", "build", "openssl_prefix=#{openssl.opt_prefix}", "OPENSSL_PREFIX=#{openssl.opt_prefix}"

    # Determine the output path based on architecture
    # The build system uses arm64v8 for ARM64 and x86-64 for Intel
    module_files = Dir.glob("bin/*-release/redistimeseries.so")

    odie "Module not found at expected path: bin/*-release/redistimeseries.so" if module_files.empty?

    lib.install module_files.first
  end

  def post_install
    # Set execute permissions on the module
    source_module = lib/"redistimeseries.so"
    chmod 0755, source_module
  end

  def caveats
    <<~EOS
      RedisTimeSeries module has been installed to:
        #{opt_lib}/redistimeseries.so

      This module is designed to extend Redis with JSON data types.
    EOS
  end

  test do
    # Test that mimics exactly how Redis loads modules
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <dlfcn.h>

      int main() {
        void *handle;
        int (*onload)(void *, void **, int);

        // Load module like Redis does
        handle = dlopen("#{lib}/redistimeseries.so", RTLD_NOW|RTLD_LOCAL);
        if (handle == NULL) {
          fprintf(stderr, "Module #{lib}/redistimeseries.so failed to load: %s\\n", dlerror());
          return 1;
        }

        // Find RedisModule_OnLoad symbol like Redis does
        onload = (int (*)(void *, void **, int))(unsigned long) dlsym(handle, "RedisModule_OnLoad");
        if (onload == NULL) {
          dlclose(handle);
          fprintf(stderr, "Module does not export RedisModule_OnLoad() symbol. Module not loaded.\\n");
          return 1;
        }

        printf("RedisTimeSeries module loaded successfully\\n");
        dlclose(handle);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test"
    assert_match "RedisTimeSeries module loaded successfully", shell_output("./test")
  end
end
