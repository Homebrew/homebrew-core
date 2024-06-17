class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/refs/tags/2.0.1.post1.tar.gz"
  version "2.0.1.post1"
  sha256 "6b276c857c69ee5ec3e292c3401c8c972bae292e0e4cb306bb9e5466c0f14737"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "19357aa9fc753df6791bf5a1764dbb2fdfeed8cdcc3a6b5c8174a052558cd8e2"
    sha256 cellar: :any,                 arm64_ventura:  "4c9ea5656b2834aaa6a4fecd8bfc55ebc0b5fdd9f8ae360dca4ada9d25d7a484"
    sha256 cellar: :any,                 arm64_monterey: "fc3a7ffad1c200b9dbb4eeb843d06eb9b6edf8313d42b38c9ca58f23e70810cc"
    sha256 cellar: :any,                 arm64_big_sur:  "3ca1e960e66e83079c74b602e268db6f634cbd9c44ea52f18da8e71c29f67a43"
    sha256 cellar: :any,                 sonoma:         "e092a3f6f7fbaa3483b3fa2b892da569adb0e3773aed3135aafe3eb9de132210"
    sha256 cellar: :any,                 ventura:        "475d61a10d43ec74d07defb155d2ae5c53422d2fd4f9c3dd09f7fbaef3b6b4c5"
    sha256 cellar: :any,                 monterey:       "37bdc2d1067fe898c5455cdb0c0d2a2b94b5f8190d41352ebf661716352d5ae4"
    sha256 cellar: :any,                 big_sur:        "cfd01c643cfc2283b4e973ba0208bbed3ee081408796c7a95059ed98f758900d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45a8a230a4a63c46fc1d9a63e4d3a8ea33e6448051200bb202c23081efc96f2"
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
