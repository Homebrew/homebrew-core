class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.008.tar.gz"
  sha256 "1d19f4cd186eec3dfb363571e3fe2e6d3377386ead6febc6ad45402f0634d2a6"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "dc55e6bf368d49b4a7d74724d40cf391c6b5851c990eb09038b3bf1c5ca4b5f2"
    sha256 arm64_monterey: "cab7366ce717706d1f2d7561d7f3d33aeeb8b6970d8935705d6ea5887ebc4903"
    sha256 arm64_big_sur:  "8e8592064ed92f1ef2ae1366d4b7d5d4577ee9ed9a17e904b3d552968094c3fd"
    sha256 ventura:        "b0005019a659e484ed1764e7409193a433fb37238afb03f1474b0a58136b80a9"
    sha256 monterey:       "dfbfb7e4fad62af9d10c2dd04899415e76b4a024f3478bea5354cb165b7b17ab"
    sha256 big_sur:        "9e5217141d3bc5b9dbcbeaaa3e50eb8f2424a800bfeefa3f39e900eaa7aa3e4d"
    sha256 x86_64_linux:   "c1f7bd3051e2f0da6ffab35981d45ba0c2e7731a5c99b61097425cd266ca1f5c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  # error: specialization of 'template<class _Tp> struct std::hash' in different namespace
  fails_with gcc: "5"

  def install
    system "autoconf"
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
    system bin/"verilator", "-Wall", "--cc", "test.v", "--exe", "test.cpp"
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
