class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/2.0.0.tar.gz"
  sha256 "67b445c760e2bbac663e8c8bc410e43311c7fc92df4dfa8d90e06a021d07f634"
  license "GPL-2.0"
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7aab257cfb71ae35a05ad57f9403f318eb00d72bcef0ba8cd7bb1c589a1b3853"
    sha256 cellar: :any,                 arm64_big_sur:  "830145199dbb7748b9e5a5f98914e92a010e393864156462fcea1bb351be8fd4"
    sha256 cellar: :any,                 monterey:       "ad5055198c408a6a7a2a1a31dc197be3a0fe17d0ffe9429f7c3d7f46b896ef1b"
    sha256 cellar: :any,                 big_sur:        "bea80a84bc5b02e7a3f6c4823bbd1df374a6a19be367271c18932d0d6ee5fc6b"
    sha256 cellar: :any,                 catalina:       "dcae27581f0a38a4a788d316f2a21028594b828a4d104e51f19df86b7e2aabcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d94aa6ca35118429ff913104b9e7d409bc12bc48b480f0e4fc81b509f2847a"
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
