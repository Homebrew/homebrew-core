class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-3.924.tgz"
  sha256 "7dcb19711b8630ada59f0d3d7409faa9649e37bf4c53a0bbfcad32afb28b5975"

  bottle do
    sha256 "28a4b0ee945c627e3454fecc57d4b3f1863f3675eaac9bd1b582143fc9cdd743" => :high_sierra
    sha256 "7dc049c54ad33542b7698b2721ee5572e8426ef94c35a65cf9efa75f5ddf9d71" => :sierra
    sha256 "4c8f74ce0af98547d1df7a92cfb7ba68097584335768eea761823a8a4ba301fc" => :el_capitan
  end

  head do
    url "http://git.veripool.org/git/verilator", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
