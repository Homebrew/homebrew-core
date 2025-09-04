class Uvwasi < Formula
  desc "WASI syscall API built atop libuv"
  homepage "https://github.com/nodejs/uvwasi"
  url "https://github.com/nodejs/uvwasi/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "cdb148aac298883b51da887657deca910c7c02f35435e24f125cef536fe8d5e1"
  license "MIT"
  head "https://github.com/nodejs/uvwasi.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b31bdacb3dce4e40fd0ac0e6336b1b7b1c22e8dd5fe5cfafc0b51bce6929f45"
    sha256 cellar: :any,                 arm64_sonoma:  "cf6eb3a3af1367282339d67f382e6de64784acbb6ae2b187e0426eccde316b19"
    sha256 cellar: :any,                 arm64_ventura: "5d12020d1e8759edd22722fc6ec2aa5a612caf8ce866d99a9ec3ab56b0b62037"
    sha256 cellar: :any,                 sonoma:        "392d42e11570e542d8c92a15e9dee999a54123a4c6b5ce3a62bc8bb9c9f60a31"
    sha256 cellar: :any,                 ventura:       "6f9d934dcf6137d14f5d7ca900bb4b98fabdc75f54b4ff50c1a5bf0d7887e08f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3afd69d0ff59b4e9582c30ba2eba0e1191189fdbf60b90c78f780abe14f8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "583140b528fddaf20e1206d0eadf158ac95dd4f7e00f14b8605c08c2c60f5f8f"
  end

  depends_on "cmake" => :build
  depends_on "libuv"

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
