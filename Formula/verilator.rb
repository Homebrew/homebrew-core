class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.228.tar.gz"
  sha256 "be6af6572757013802be5b0ff9c64cbf509e98066737866abaae692fe04edf09"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    rebuild 1
    sha256 arm64_monterey: "8e5f635658b007f27fecaece0588bd715f1e12ae4aead2170a45a0bedc3bd766"
    sha256 arm64_big_sur:  "4905b78faa6c65c317680e8904704bc0c11d0cb5e4a5d6d51390adafbc8056aa"
    sha256 monterey:       "669276002757d11080befc9a6cb22bcd491e4df70390a63db9674fe56a02f54c"
    sha256 big_sur:        "696a5c432c02769cf383d279e0aad7de1fbca58262f3c03cd1a2608b8a512c10"
    sha256 catalina:       "66810bc435954d3f8dfb3016ac31d7e557bd5c7ff2932c91f614ba505f9592df"
    sha256 x86_64_linux:   "41b0a1e5d3f0ba30284ef69f887a49e2af4e9bb76c546c3a7f6c204cc347b2ae"
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
