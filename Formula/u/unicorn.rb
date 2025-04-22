class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/refs/tags/2.1.3.tar.gz"
  sha256 "5572eecd903fff0e66694310ca438531243b18782ce331a4262eeb6f6ad675bc"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "be54fd832159f1d3fda1b1c23e01f2f4a981df0b2832bf6dc3421fde20f8d2ba"
    sha256 cellar: :any,                 arm64_sonoma:  "ad018ba42442daad5e4dfd902d6dff8ad851c4540d18c268f513e6f2f70e8cd4"
    sha256 cellar: :any,                 arm64_ventura: "2be056cfd6cfbd60ee30fefee65a8d6bfefd0fce7a15b2e9d7b14f7fa0fb26c8"
    sha256 cellar: :any,                 sonoma:        "dbe751ecc5f13bb438892e671ef7efa7a5d4fa4b82c25fb110ea587bc46ce74e"
    sha256 cellar: :any,                 ventura:       "79c598b769e4368bc5ec5f49468f4a00652703945d567b3fe5b193dc093fffb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7baa47e32d8535154a863fd96ca1692451cb0b5bffe63fcb6aeae783d69a9802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a61ebcf75b64b23cd9c1043d08e1ab680d6f1d752538b42d72a8b33bbc7c0e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DUNICORN_SHARE=yes", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test1.c").write <<~C
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
    C
    system ENV.cc, "-o", "test1", "test1.c", "-pthread", "-lpthread", "-lm", "-L#{lib}", "-lunicorn"
    system testpath/"test1"
  end
end
