class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.220.tar.gz"
  sha256 "e00e0c31a0c00887bebbaf7a8c771efa09420a4d1fbae54d45843baf50df4426"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    sha256 arm64_monterey: "7de06c545a95536c74dd987d1a77e58e5c6e9f09d8710041e92cc4bef6e9b054"
    sha256 arm64_big_sur:  "90eecfdacaca3833bd899cfdb2b8f74454f6a6ef783d9b5935fdb65512db48da"
    sha256 monterey:       "182da3bdf014340bf5ac47f2c77a3eef838961df233e4df18d62907e216a2654"
    sha256 big_sur:        "af3582a28039e325d1785ee3e72c309336c2e408bae1bc6bf35085173e0d938b"
    sha256 catalina:       "7045124321f7a7d33d40f4de72820ccf45a0eb0c06e6ebd4f15b198f33aae78f"
    sha256 x86_64_linux:   "8de13337e7f196addb5ad8d4a1541c38023f932d29c5882c0199c4de1a3962dd"
  end

  head do
    url "https://github.com/verilator/verilator.git", using: :git
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

  on_linux do
    depends_on "gcc"
  end

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
