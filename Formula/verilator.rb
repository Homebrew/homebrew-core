class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.108.tgz"
  sha256 "8e8ec1de0bf200b6206035214f9071a5acc64bd2e7134361d564271e48552702"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  livecheck do
    url "https://github.com/verilator/verilator.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "45d7504fefb899372cd2ee8876e8a82d56b59f14972309b9dbeed83b580029b3" => :big_sur
    sha256 "54cb01cc42dcbb937393cb3359459b18c4cc29c424d19065b09f1095fdee685b" => :arm64_big_sur
    sha256 "8e616f827d635b2659f454a3f5dc302fced30bad4b26930ccd392944f71dbfd9" => :catalina
    sha256 "97797a992b626adf8ae83c8ee22d881ec26bf12f390c6a807e0635bc67d6e09b" => :mojave
  end

  head do
    url "https://git.veripool.org/git/verilator", using: :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "python@3.9" => :build
  uses_from_macos "perl"

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    EOS
    system "/usr/bin/perl", bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
    cd "obj_dir" do
      system "make", "-j", "-f", "Vtest.mk", "Vtest"
      expected = <<~EOS
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end
