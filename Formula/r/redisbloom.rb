class Redisbloom < Formula
  desc "Probabilistic data structure for Redis"
  homepage "https://github.com/redisbloom/redisbloom"
  url "https://github.com/redisbloom/redisbloom.git",
      tag:      "v8.6.0",
      revision: "fd8f01c9f13a8d6424481e8c6c9316178f8601b2"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-3-Clause", # deps/readies, deps/bloom
    "MIT", # deps/RedisModulesSDK, deps/t-digest-c
  ]
  head "https://github.com/redisbloom/redisbloom.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "coreutils" => :build
  depends_on "llvm@18" => :build
  depends_on "make" => :build
  depends_on "python@3.14" => :build

  depends_on "openssl@3"

  def install
    # Add GNU tools to PATH (required by build system)
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    ENV.prepend_path "PATH", Formula["llvm@18"].opt_bin

    # Set minimum SDK version for macOS
    if OS.mac?
      ENV["OSX_MIN_SDK_VER"] = case MacOS.version
      when :tahoe then "26.0"
      when 15 then "15.0"
      when 14 then "14.0"
      else MacOS.version.to_s
      end
    end

    # Build the module
    system "make", "all"

    module_files = Dir.glob("bin/*-release/redisbloom.so")

    lib.install module_files.first
  end

  def post_install
    # Set execute permissions on the module
    source_module = lib/"redisbloom.so"
    chmod 0755, source_module
  end

  def caveats
    <<~EOS
      RedisBloom module has been installed to:
        #{opt_lib}/redisbloom.so

      This module is designed to extend Redis with probabilistic data structures.
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
        handle = dlopen("#{lib}/redisbloom.so", RTLD_NOW|RTLD_LOCAL);
        if (handle == NULL) {
          fprintf(stderr, "Module #{lib}/redisbloom.so failed to load: %s\\n", dlerror());
          return 1;
        }

        // Find RedisModule_OnLoad symbol like Redis does
        onload = (int (*)(void *, void **, int))(unsigned long) dlsym(handle, "RedisModule_OnLoad");
        if (onload == NULL) {
          dlclose(handle);
          fprintf(stderr, "Module does not export RedisModule_OnLoad() symbol. Module not loaded.\\n");
          return 1;
        }

        printf("RedisBloom module loaded successfully\\n");
        dlclose(handle);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test"
    assert_match "RedisBloom module loaded successfully", shell_output("./test")
  end
end
