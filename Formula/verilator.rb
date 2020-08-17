class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.040.tgz"
  sha256 "6e1574924083922a4eb80ff22eedc866f4ce54e5fd6a34101b6af7aa29e5c0e3"
  license "LGPL-3.0"

  bottle do
    sha256 "262db50617a00e4f3fa85f1458808f61c531cd273e0dc0d5c1ee908ecd3bf9f5" => :catalina
    sha256 "2bd4bb491dd8b2a1a1780d84d5a246b9c75899b1922e4dbbdbad05f16757532a" => :mojave
    sha256 "4687c0800cb5961f66b04c0844e101eb9f54ebaab5e8ac8f50c3bd0261109376" => :high_sierra
  end

  head do
    url "https://git.veripool.org/git/verilator", using: :git
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
