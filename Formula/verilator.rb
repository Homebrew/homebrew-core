class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.218.tar.gz"
  sha256 "ef7b1e6ddb715ddb3cc998fcbefc7150cfa2efc5118cf43ddb594bf41ea41cc7"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    sha256 arm64_monterey: "64e904c9c83ab057476ed63a80277656df6d554f30d589c82b42333ca2ec9866"
    sha256 arm64_big_sur:  "7b9d457edce98a8703f88ed0f646c0a1cb33f6a51d9cfc2778e61040ea76cf80"
    sha256 monterey:       "26efe02e1808eee8ebc6bc480c27bd886f4024a49f4ced13c56655eec2acf4a6"
    sha256 big_sur:        "40459e084b741bffc67f6e7b72cf0c701428415434ad23ba635cf3fda9840276"
    sha256 catalina:       "e0158aa800c6028a36f456d7e60a4b1ef102c863e03e8f4b83dd0a6261cf898d"
    sha256 x86_64_linux:   "f337bdd7247fbb8a3245d28fa4531d69af420047e0058557f601ea8eefad9661"
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

  skip_clean "bin" # Allows perl scripts to keep their executable flag

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
