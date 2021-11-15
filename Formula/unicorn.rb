class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/1.0.3.tar.gz"
  sha256 "64fba177dec64baf3f11c046fbb70e91483e029793ec6a3e43b028ef14dc0d65"
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "ff8f7998c9431695a9e43a5c25de40bc509bed4d23b1178cfe22b3e4c81f0a5e"
    sha256 cellar: :any,                 big_sur:      "8f7ec73074e986c355944923dfc2c4828b9a545e66f9112e92b20cd11cf3b1b4"
    sha256 cellar: :any,                 catalina:     "11c4212e8e10b202eb2b9c4d4704d9c18619523d1ed31b98eb7eb5288a4ea7c1"
    sha256 cellar: :any,                 mojave:       "3725cd02674803b1491af58d6552a842af5ed8e1bd16b2144dd1e971748502aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0e3136c1be33d317e52a1689c24ad785617a3102dcd69052fe0a43e63638c7cc"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => [:build, :test]

  def install
    ENV["PREFIX"] = prefix
    ENV["UNICORN_ARCHS"] = "x86 x86_64 arm mips aarch64 m64k ppc sparc"
    ENV["UNICORN_SHARED"] = "yes"
    ENV["UNICORN_DEBUG"] = "no"
    system "make"
    system "make", "install"

    cd "bindings/python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
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

    system Formula["python@3.9"].opt_bin/"python3", "-c", "import unicorn; print(unicorn.__version__)"
  end
end
