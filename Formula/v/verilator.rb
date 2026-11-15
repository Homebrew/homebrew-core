class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.054.tar.gz"
  sha256 "18658731b46922ef660bcb650be0aa503d751e5c17eb9d4644fdfabb11835198"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "977c1c40552522c2dc5d71a190547b00a40f67a9e4ef7c5a7157dcb4a116c6d2"
    sha256 arm64_tahoe:       "5b18598ea779983c69b09f65ff7d5cf7385470337b380d782ff82910ecb4f383"
    sha256 arm64_sequoia:     "f3e0ae1fbed848217fc8d4151a98fbf5e6ddf0c7a15c1da092c69c369ec38b09"
    sha256 arm64_linux:       "a15e7001126b0f915e00d4162d37791b2645ec4a4f492125698d464783cb60dc"
    sha256 x86_64_linux:      "ae61306c19ea1b8f570bd02327b784a0787b0345adff1caf4b0fc4d3d37eac25"
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
