class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/refs/tags/2.1.1.tar.gz"
  sha256 "8740b03053162c1ace651364c4c5e31859eeb6c522859aa00cb4c31fa9cbbed2"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d883e9c493f37e9bb7e98824a64d2ecfbee8d03ce0a3bfce3558a3805ac9ae16"
    sha256 cellar: :any,                 arm64_sonoma:  "b73d76012c194c5b982c12a36a380f7d3db64dbc828c3566ed783e8955a59640"
    sha256 cellar: :any,                 arm64_ventura: "8cb9b6e44b8f70a0e9cf1da0ba23dc7f9a0cbafaa5e2044f83166918dc5560e0"
    sha256 cellar: :any,                 sonoma:        "e435e55606cdbc842e79367eac3dc8974267616f08ea95b890c2086c634137b0"
    sha256 cellar: :any,                 ventura:       "aeb5bf15f1613f87677b7bb539cac1bc9b3fcd339f06881437058ed19ac5313a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8935edc693fe1e8f5756c96913bf9de63aed9d22be914ef6a7b40dff96686e61"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DUNICORN_SHARE=yes"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test1.c").write <<~EOS
      /* Adapted from https://www.unicorn-engine.org/docs/tutorial.html
       * shamelessly and without permission. This almost certainly needs
       * replacement, but for now it should be an OK placeholder
       * assertion that the libraries are intact and available.
       */

      #include <stdio.h>

      #include <unicorn/unicorn.h>

      #define X86_CODE32 "\x41\x4a"
      #define ADDRESS 0x1000000

      int main(int argc, char *argv[]) {
        uc_engine *uc;
        uc_err err;
        int r_ecx = 0x1234;
        int r_edx = 0x7890;

        err = uc_open(UC_ARCH_X86, UC_MODE_32, &uc);
        if (err != UC_ERR_OK) {
          fprintf(stderr, "Failed on uc_open() with error %u.\\n", err);
          return -1;
        }
        uc_mem_map(uc, ADDRESS, 2 * 1024 * 1024, UC_PROT_ALL);
        if (uc_mem_write(uc, ADDRESS, X86_CODE32, sizeof(X86_CODE32) - 1)) {
          fputs("Failed to write emulation code to memory.\\n", stderr);
          return -1;
        }
        uc_reg_write(uc, UC_X86_REG_ECX, &r_ecx);
        uc_reg_write(uc, UC_X86_REG_EDX, &r_edx);
        err = uc_emu_start(uc, ADDRESS, ADDRESS + sizeof(X86_CODE32) - 1, 0, 0);
        if (err) {
          fprintf(stderr, "Failed on uc_emu_start with error %u (%s).\\n",
            err, uc_strerror(err));
          return -1;
        }
        uc_close(uc);
        puts("Emulation complete.");
        return 0;
      }
    EOS
    system ENV.cc, "-o", testpath/"test1", testpath/"test1.c",
                   "-pthread", "-lpthread", "-lm", "-L#{lib}", "-lunicorn"
    system testpath/"test1"
  end
end
