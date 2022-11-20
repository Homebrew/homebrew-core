class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/2.0.1.tar.gz"
  sha256 "0c1586f6b079e705d760403141db0ea65d0e22791cf0f43f38172d49497923fd"
  license all_of: [
    "GPL-2.0-only",
    "GPL-2.0-or-later", # glib, qemu
  ]
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c4b1c9fc5aa717c2c2fca307f30c0ace45db771d38316c9a711d20157e06f773"
    sha256 cellar: :any,                 arm64_monterey: "9c3008bf2fcffaf16ed6ad3e6419a85c494ff725be673880c3ee8a3bb3521ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "f48491de90d3fa69c91ba1136a9f0c024a6e2d4ab6c0b7c5de476d0c534b56f0"
    sha256 cellar: :any,                 ventura:        "7d3d7650e7ba1589a979338ba66ecc12d2d89bc81e000c0da9a45d3b5e7daf70"
    sha256 cellar: :any,                 monterey:       "a73d5bb66602ec714ff8f292fb7bbf9e274220f0251c91cb68e948f7463c3a2a"
    sha256 cellar: :any,                 big_sur:        "859db47d54b2b8af4419765f68cc39b22110f1934bdeb0c59e774f7b2fe77b4b"
    sha256 cellar: :any,                 catalina:       "b06bdfa3516c07d3203fa5182318145743ad7aa3ff8e69b362fd08b6b7e0baca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7471dee211f51d19b357866fc48756aa1810ec1940bf72c990dc19ea350f666"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  # upstream issue, https://github.com/unicorn-engine/unicorn/issues/1730
  # build patch ref, https://github.com/NixOS/nixpkgs/pull/199650
  patch :DATA

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

__END__
diff --git a/tests/unit/endian.h b/tests/unit/endian.h
index 5bc86308..b455899e 100644
--- a/tests/unit/endian.h
+++ b/tests/unit/endian.h
@@ -54,6 +54,7 @@
    || defined(_POWER) || defined(__powerpc__) \
    || defined(__ppc__) || defined(__hpux) || defined(__hppa) \
    || defined(_MIPSEB) || defined(_POWER) \
+   || defined(__ARMEB__) || defined(__AARCH64EB__) \
    || defined(__s390__)
 # define BOOST_BIG_ENDIAN
 # define BOOST_BYTE_ORDER 4321
@@ -63,6 +64,7 @@
    || defined(_M_ALPHA) || defined(__amd64) \
    || defined(__amd64__) || defined(_M_AMD64) \
    || defined(__x86_64) || defined(__x86_64__) \
+   || defined(__ARMEL__) || defined(__AARCH64EL__) \
    || defined(_M_X64) || defined(__bfin__)

 # define BOOST_LITTLE_ENDIAN
