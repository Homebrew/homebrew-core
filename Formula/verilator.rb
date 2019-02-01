class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.010.tgz"
  sha256 "5651748fe28e373ebf7a6364f5e7935ec9b39d29671f683f366e99d5e157d571"

  bottle do
    sha256 "84c91ebd242e484a9e27fd1d021fe23ffd401d0d8ede93d11cf89ed692685a0e" => :mojave
    sha256 "c1e2097d8982d930291f9b875ee30c0906914c8b6226d1163bedf4c69979a88e" => :high_sierra
    sha256 "780bc1bca97ba26494d0249609879b9036bb46c7afc34e223be7974a36264181" => :sierra
  end

  head do
    url "http://git.veripool.org/git/verilator", :using => :git
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
