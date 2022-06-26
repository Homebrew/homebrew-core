class Unicorn < Formula
  desc "Lightweight multi-architecture CPU emulation framework"
  homepage "https://www.unicorn-engine.org/"
  url "https://github.com/unicorn-engine/unicorn/archive/1.0.3.tar.gz"
  sha256 "64fba177dec64baf3f11c046fbb70e91483e029793ec6a3e43b028ef14dc0d65"
  head "https://github.com/unicorn-engine/unicorn.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 monterey:     "8a4345c49a4c8332c4a35eb97446c47aeed1a727cec98ce881ad9b8439047dc5"
    sha256 cellar: :any,                 big_sur:      "6768c979e8d8a6e01eae16bcbcb86e5108f3aa24f60e400ffff61fe6f3282218"
    sha256 cellar: :any,                 catalina:     "77d22ad4c7dc3901b741ea34c777d90e6cee40beac3dca3e5cfab66deadc7886"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3559c25bdd368abb656250e8bb38441ec23bd9099cc336355acda780a5f3e8fe"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]

  def install
    ENV["PREFIX"] = prefix
    ENV["UNICORN_ARCHS"] = "x86 x86_64 arm mips aarch64 m64k ppc sparc"
    ENV["UNICORN_SHARED"] = "yes"
    ENV["UNICORN_DEBUG"] = "no"
    system "make"
    system "make", "install"

    cd "bindings/python" do
      system Formula["python@3.10"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
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

    system Formula["python@3.10"].opt_bin/"python3", "-c", "import unicorn; print(unicorn.__version__)"
  end
end
