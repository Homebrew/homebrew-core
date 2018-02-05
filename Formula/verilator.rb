class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-3.920.tgz"
  sha256 "2b5c38aa432d0766a38475219f9548d64d18104ce8bdcb5d29e42f5da06943ff"

  bottle do
    sha256 "a7045ca8a5e19a660636aa0b52c8d5f3333799a068353314570f4d952eace01b" => :high_sierra
    sha256 "edb227b38ec501c4188cfe809133115f299a6425230e9328a26ad28efb47673d" => :sierra
    sha256 "443be0517c89747bbc8dc56fdd2f2fbf837b44f4b9ddf01c68ce99be7f51acda" => :el_capitan
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
