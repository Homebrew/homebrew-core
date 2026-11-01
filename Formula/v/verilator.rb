class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.054.tar.gz"
  sha256 "18658731b46922ef660bcb650be0aa503d751e5c17eb9d4644fdfabb11835198"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "66a097432fffcf28165bcce9b74beae19a3c5d86e931226ff0fa76f131b73054"
    sha256 arm64_tahoe:       "e7feb1dd658e25f1fb18ee4b1ef4f54e865685041f59f02c1f1b19aa6acba3bb"
    sha256 arm64_sequoia:     "94ddddacd076100014c0b238781046f965a9b388f1323dbd5b91d4fcd221b4a9"
    sha256 arm64_linux:       "b45364801472a41bec00e3e088878d581d15e6a700e997e3a361cd7848ff5b3f"
    sha256 x86_64_linux:      "57851f051cf12172e355fc7b7566d55dc69c76174a03937f2532409f4f93b72a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  # macOS 27's system flex emits `yy_create_buffer(FILE *, yy_size_t)`, mismatching `src/V3PreLex.h`
  depends_on "flex" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "perl"
  uses_from_macos "python"

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}"
    # `make` and `make install` need to be separate for parallel builds
    system "make"
    system "make", "install"

    # Avoid hardcoding build-time references that may not be valid at runtime.
    inreplace pkgshare/"include/verilated.mk" do |s|
      s.change_make_var! "CXX", "c++"
      s.change_make_var! "LINK", "c++"
      s.change_make_var! "PERL", "perl"
      s.change_make_var! "PYTHON3", "python3"
    end
  end

  test do
    (testpath/"test.v").write <<~VERILOG
      module test;
         initial begin $display("Hello World"); $finish; end
      endmodule
    VERILOG
    (testpath/"test.cpp").write <<~CPP
      #include "Vtest.h"
      #include "verilated.h"
      int main(int argc, char **argv, char **env) {
          Verilated::commandArgs(argc, argv);
          Vtest* top = new Vtest;
          while (!Verilated::gotFinish()) { top->eval(); }
          delete top;
          exit(0);
      }
    CPP
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
