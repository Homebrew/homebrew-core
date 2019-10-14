class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.018.tgz"
  sha256 "98d52ec125d21b452a8b0bfddf336d8f792a53449db26798978f47885a430346"

  bottle do
    sha256 "663562fc11c3415f3a455a76913e124c8c2ebafd41843b20ba2890502d0d58ea" => :catalina
    sha256 "66754e828ca8b23ab4aadc78172915b9a8100c577a5e5974e95d3ce8d94c2eea" => :mojave
    sha256 "90caf39e46aaeef978c8f403ecaf3f876d99473d4dc822df9cc83367f83390e7" => :high_sierra
    sha256 "6c4d40b6ce3fdb1f24beb99d9d57e1471cbb40f4e8fbe3f6c90071f616e0789a" => :sierra
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
