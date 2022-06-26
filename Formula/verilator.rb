class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.222.tar.gz"
  sha256 "15c60175807c0f3536c3c5b435f131c2b1e8725aefd30645efd946bf401b4c84"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    sha256 arm64_monterey: "5a48bc3e58b0499750fdc8f3d926e29af8afc27ba0ecac7f2f79b503297b62af"
    sha256 arm64_big_sur:  "f1953605d3898a939a10fa152162d50b4e8e9589c618c074fdb98f948efd6c65"
    sha256 monterey:       "a950ad2b221808fdde684e2e24f5fd50f0ce6ee0c1b2ce6e752e4fb2a2759369"
    sha256 big_sur:        "dde40b13efcd5a4d794ef151b081a4dfdb388838aa7cf6e4b200719dc1b7d63a"
    sha256 catalina:       "b0c0d73fd8dc0ee7616b249f4be4df0737d9173f543340a6866539dd51889280"
    sha256 x86_64_linux:   "5e0b36efd56d4e12b67bc783aa467523be74355a9c22cb10030a9419cacfdf57"
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
