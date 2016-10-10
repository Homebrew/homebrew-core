class Verilator < Formula
  desc "Verilog simulator"
  homepage "http://www.veripool.org/wiki/verilator"
  url "http://www.veripool.org/ftp/verilator-3.886.tgz"
  sha256 "d21c882e0c079ade4b155cb4a763f7d246decead8b38d2d0aad8d1dd03e0f77d"

  bottle do
    sha256 "92bfd3a1c0254181993088ce7b139aea42df28ddebc71c2ad2a358a2c14e0b44" => :sierra
    sha256 "24fac1b570220c9616f00bfc6c52ce75df4bfc6b25f58c8770da8e6690114cbb" => :el_capitan
    sha256 "cea32dc698d89578e0e08a4e947b2117d12e0aac25561313ee052ab1c4a19a59" => :yosemite
    sha256 "133e859467db7fe6bd8888467f2be0ce165025f32581236f018642d88f0c1d06" => :mavericks
  end

  head do
    url "http://git.veripool.org/git/verilator", :using => :git
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # Needs a newer flex on Lion (and presumably below)
  # http://www.veripool.org/issues/720-Verilator-verilator-not-building-on-Mac-OS-X-Lion-10-7-
  depends_on "flex" if MacOS.version <= :lion

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.v").write <<-EOS.undent
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    EOS
    (testpath/"test.cpp").write <<-EOS.undent
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
      expected = <<-EOS.undent
        Hello World
        - test.v:2: Verilog $finish
      EOS
      assert_equal expected, shell_output("./Vtest")
    end
  end
end
