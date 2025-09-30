class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/refs/tags/2.1.4.tar.gz"
  sha256 "ea8863f095a0136388694e5a6063afd9bb7650e30243dd6251af59c5ce5601f4"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e317a3a90c3c1209bd849383f6b3a4b12c4bce696e1265c86ed4f4982581d274"
    sha256 cellar: :any,                 arm64_sequoia: "717aaa05f34162a41e10f5abfe602e4782dd96f36f430cf95a54a383f946a138"
    sha256 cellar: :any,                 arm64_sonoma:  "ea180ba3dcebf82a08b4f609d165939c6882117b5b05d928ce82ca9e932f9a4c"
    sha256 cellar: :any,                 arm64_ventura: "4840fa33b6992f0c941c4df168c856af825d1e4304a8c3b93f61dab9a72e6adb"
    sha256 cellar: :any,                 sonoma:        "b5fa6de6bd6cc5724e389317ad7e9aeddab31d79fa80c27570b728476e9d47c5"
    sha256 cellar: :any,                 ventura:       "b5867abd468fce9779267faa65115f42986a2d5d4d6f59d2af0c6c39b726dc45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c31c5817a5dee6699a2e9e0f520bd2e5084b6c94a230ddf602ad8c076cac1599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d95c484b1fb36c5a31dc3c5e2d6d20881de4ec035f20263e190f2bd33005d96"
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
