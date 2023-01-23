class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.006.tar.gz"
  sha256 "eb4ca4157ba854bc78c86173c58e8bd13311984e964006803dd45dc289450cfe"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "3eb15f62df1c3bc4e746c5c87b0e5fc754c7b112cfd740a6396ecb292732f59b"
    sha256 arm64_monterey: "6ed63f0d2c73a6a6a30f79bb1724425ff86516cc025bb90f2b6162d1e874b49d"
    sha256 arm64_big_sur:  "885d5183c418ee06c4010af9cef9dce6145f3e88c18339e29271c7f504a24b3a"
    sha256 ventura:        "b6cc61b640c35328200463b173f145b0879f6d0321b79091776c76b4425cf339"
    sha256 monterey:       "4e5c87f959617510373c5b255fc54b79772338d32fce2c42793e1769ff3517e0"
    sha256 big_sur:        "dbf9cf4ee0c3b4b2aa5ccd73948d7db0dd096375e7279fea2557581f5d0377ac"
    sha256 x86_64_linux:   "896b28ff444f53df0f94b51162be2dfd83d7d0f029d6d2fa83570453a73bb21a"
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
