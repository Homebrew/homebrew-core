class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.008.tgz"
  sha256 "d5cef6edd3bdb7754776d902daae7a7e5dd662baa7c7f895cb7028b1d6910cac"

  bottle do
    sha256 "05cdfe0a8555d10f43f6af2b8e820f80591b00df62628deff8f6ee9cff7a3cc6" => :mojave
    sha256 "a3e8106bf822313e78b42e887cca373d48ca1307868cb5bcd4a602ba8b8bff2f" => :high_sierra
    sha256 "7b381623263dd15f4244f9fc447bf2134799c0b1579aee2af56b2e0916a06b62" => :sierra
  end

  head do
    url "http://git.veripool.org/git/verilator", :using => :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # Needs a newer flex on Lion (and presumably below)
  # https://www.veripool.org/issues/720-Verilator-verilator-not-building-on-Mac-OS-X-Lion-10-7-
  depends_on "flex" if MacOS.version <= :lion

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
