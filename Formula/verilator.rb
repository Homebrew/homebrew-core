class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.030.tgz"
  sha256 "7e7a3c0acac77e7fda36678a71f50e6c2f54d5af4ba05e5bb061e4d98f9b8d1e"

  bottle do
    sha256 "bb71805f6be3d64d2409a541dd0390960a93c978d14096766cc5652b35124237" => :catalina
    sha256 "f5c4da84c7f08383e77f8af7984c91de4b48ea72de3996a90b8e508ea0df8b27" => :mojave
    sha256 "d56fb5be0898bfc665a480bd177b9022781a6620ed54471fa667410f3334d2f5" => :high_sierra
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
