class Uvwasi < Formula
  desc "WASI syscall API built atop libuv"
  homepage "https://github.com/nodejs/uvwasi"
  url "https://github.com/nodejs/uvwasi/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "cdb148aac298883b51da887657deca910c7c02f35435e24f125cef536fe8d5e1"
  license "MIT"
  head "https://github.com/nodejs/uvwasi.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c2742f168c40ecdcf97566b4bbca3419dc010995edbd25fd2805c45cccbe11fd"
    sha256 cellar: :any,                 arm64_sequoia: "3bbe2380eb184f540f5b23a9cd2f92ef21a4779b04ff6068b6c3a0b4e7865c7e"
    sha256 cellar: :any,                 arm64_sonoma:  "923e457efe87a95fd53031ca80440ce09ab3862a9ac7df374b3fe634c7001c23"
    sha256 cellar: :any,                 sonoma:        "74534d557b0603f0fac5d6b4e98257bee2f372c55e0eabf97b0ac5ccbd10415d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc607f16b816da2d32a2d8a3eec770c64f8a497524dd1a33d5b6f252db0ac44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2befd108f0cf4fffab4832dc834e0b7c4b8aec470ad95994435792c6b3ab9bcc"
  end

  depends_on "cmake" => :build
  depends_on "libuv"

  # Apply open PR to remove find_dependency in CMake configuration file
  # PR ref: https://github.com/nodejs/uvwasi/pull/313
  patch do
    url "https://github.com/nodejs/uvwasi/commit/fcc0be004867939389aba3cc715ea90b86ab869c.patch?full_index=1"
    sha256 "4a3a388e9831709089270b7c6bc779d86257857192dee247d32ec360cd7819cc"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Adapted from "Example Usage" in README.
    (testpath/"test-uvwasi.c").write <<~C
      #include <stdlib.h>
      #include <string.h>
      #include "uv.h"
      #include "uvwasi.h"

      int main(void) {
        uvwasi_t uvwasi;
        uvwasi_options_t init_options;
        uvwasi_errno_t err;

        memset(&init_options, 0, sizeof(init_options));

        /* Setup the initialization options. */
        init_options.in = 0;
        init_options.out = 1;
        init_options.err = 2;
        init_options.fd_table_size = 4;

        init_options.argc = 1;
        init_options.argv = calloc(init_options.argc, sizeof(char*));
        init_options.argv[0] = strdup("test-uvwasi");

        init_options.envp = calloc(1, sizeof(char*));
        init_options.envp[0] = NULL;

        init_options.preopenc = 1;
        init_options.preopens = calloc(1, sizeof(uvwasi_preopen_t));
        init_options.preopens[0].mapped_path = strdup("/sandbox");
        init_options.preopens[0].real_path = strdup("/tmp");

        init_options.allocator = NULL;

        /* Initialize the sandbox. */
        err = uvwasi_init(&uvwasi, &init_options);

        if (err != UVWASI_ESUCCESS) {
          fprintf(stderr, "uvwasi_init() failed: %d\\n", err);
          return 1;
        }

        /* Clean up resources. */
        uvwasi_destroy(&uvwasi);
        return 0;
      }
    C

    ENV.append_to_cflags "-I#{include} -I#{Formula["libuv"].opt_include}"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-luvwasi"

    system "make", "test-uvwasi"
    system "./test-uvwasi"
  end
end
