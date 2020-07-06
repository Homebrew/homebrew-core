class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.036.tgz"
  sha256 "307cf2657328b6e529af48c2d7d06b78b98d00d4f0148a484173cf81df15c0eb"
  license "LGPL-3.0"

  bottle do
    sha256 "b5cf626c764981beb0c7c2d687478c49aaec9def3a4c0c03def9a918630601e7" => :catalina
    sha256 "fdade70c8b1511c9c1b54ceaa9b4a067ef01091605f57af2cdf045266c28f1c9" => :mojave
    sha256 "e8adde44e999f92f597ae71e927b792071fe0b1a6dfb537f9390603da1417c0d" => :high_sierra
  end

  head do
    url "https://git.veripool.org/git/verilator", :using => :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
