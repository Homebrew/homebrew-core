class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.200.tgz"
  sha256 "773913f4410512a7a51de3d04964766438dc11fc22b213eab5c6c29730df3e36"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  revision 1

  livecheck do
    url "https://github.com/verilator/verilator.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "745234546ac4e29afcc4ed3ec60396b66a52d5f3ee1d5c50bff0b9f7adb9e6e0"
    sha256 arm64_big_sur:  "b4c783a956765b7cca12010b793fe3d8728942897107d7a37d805b53bb6b446f"
    sha256 monterey:       "b8c590f31ab771bce5fe4dbf22c95cea8ee7b9bf12cb6362016e2806f7e286c0"
    sha256 big_sur:        "2e1d4b7478d0a85ebf90aff2dfcb506ab7950a0b9469f9bd306160682c7014ee"
    sha256 catalina:       "15d0d1d9a1b335fd8bc14b35dba77e668ad723155d91e51943a11792e243f40e"
    sha256 x86_64_linux:   "402ad2a601e053d5d888d22a936013693c2c5e97df14b94febfd5203abf7a404"
  end

  head do
    url "https://git.veripool.org/git/verilator", using: :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "python@3.10" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

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
