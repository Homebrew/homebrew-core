class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-3.926.tgz"
  sha256 "f92516ccfffa8d7edecaf85d277ab0950df673a038481c4c8b53f7fa82948a38"

  bottle do
    sha256 "95501636d884bfb4ae2304c6b72bbd4eb45bfa2256708ad6631e78fd26736192" => :mojave
    sha256 "988e548a635ea2495a37054256f44cbbee17e9bbc63ef390ebe92bcffc2a7a4e" => :high_sierra
    sha256 "8daf899371dd789aceb61646d9fdfdb50e9b2a3f8a6a428a403ad36a5e1404df" => :sierra
    sha256 "0fee91b2a977b76f68612bfb0308830d8d405a77415a72618a9be318f073f013" => :el_capitan
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
