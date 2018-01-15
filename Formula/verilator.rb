class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-3.918.tgz"
  sha256 "377057a2d6ff577e54cacfead6e6ece53decd6cddfd50ec27cd45b93a599685c"

  bottle do
    sha256 "ed308764080fa2f7792675e3f41ee686e32e7da6e01e405624c10e72389ddab0" => :high_sierra
    sha256 "6b82bb9d715ad1c585c40756911f3c3ab949abd5dc2aa222722e1b2fb08f64cf" => :sierra
    sha256 "a631852aac4746089d7abcd85fc6132b3f3e4303d3e5a84d750a413d3952f07f" => :el_capitan
    sha256 "c1a75df08503dcc66c82f4417486e4c6bd1cde95388b8cceb292336a08816674" => :yosemite
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
