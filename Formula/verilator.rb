class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.220.tar.gz"
  sha256 "e00e0c31a0c00887bebbaf7a8c771efa09420a4d1fbae54d45843baf50df4426"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    sha256 arm64_monterey: "e9f24053e7505eeb00e924385ff9b468273f84e7aa3b64ce131ba477ae80a429"
    sha256 arm64_big_sur:  "edd06702161747c4af13db6839269abd4b414b897a37cd26ee6cb09f66fac35b"
    sha256 monterey:       "161e00dc2c0a532afd1cbbc59ba46d20d1e3ad07c2d532d4a2d8b4b367f213b3"
    sha256 big_sur:        "0965ac06b007d7a737f16101a89f2f2bcf1b8eb55d2386c20e51c5192a5b778b"
    sha256 catalina:       "b5ae4b2a28efbf3c0d34b8e682cf8caa3ec2dc0cc93231196488cdf8f7a46525"
    sha256 x86_64_linux:   "3b1da598b6163f140be7854ae10a610c61ffb4464f3ab577370e36b11c6afd6b"
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
