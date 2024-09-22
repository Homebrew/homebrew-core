class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/refs/tags/2.1.0.tar.gz"
  sha256 "7085001b6f707c8a072d998d1a027e26892d65348e658f07a5d38f206f58dfec"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b15ab7353cb27bd748c59549d65dab193fd5addb9fd6bdb11783b1a8fa90489b"
    sha256 cellar: :any,                 arm64_sonoma:  "38881d75368afffaddf2bf6d1ecdc12ef3729aa2ae7e85dd007c1abff6a12d74"
    sha256 cellar: :any,                 arm64_ventura: "5b4faa1a4a296d32b69fc29665883c012961e50c0f79ff8638d028eca4efa559"
    sha256 cellar: :any,                 sonoma:        "eac9ed24f43e550b97f9eccc9338779650b2a059bada6540b64153f329270ae8"
    sha256 cellar: :any,                 ventura:       "e82d38fcf74fcf7770f621839adab576c7b1e10f6a60837fdf117499dad46574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e73f7be8e9871cbf1fe86aecd85ebe5ae9e8ff921679b516b6ae4df67dd4c45"
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
