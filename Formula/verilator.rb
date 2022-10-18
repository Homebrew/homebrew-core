class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.228.tar.gz"
  sha256 "be6af6572757013802be5b0ff9c64cbf509e98066737866abaae692fe04edf09"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "892ffbcd0e96b47dd1117f4496feed9ac0135036efe1d054a21e23c6c91920b1"
    sha256 arm64_big_sur:  "a23268268b1d5dba051c3323bc710576411ed275ecc047e14f9a5ea971000f2f"
    sha256 monterey:       "e3aae130b82eec63682a3cba1fb4bd013541ee556bdf9ef8c573423bb3785cac"
    sha256 big_sur:        "354ee81bb51c5903a17ac093480630c7e06e2502972c12746816a83bbb396822"
    sha256 catalina:       "b55676954ad3fe5d75b1ad70f164793aa4ce09ed750acaa85d8f965944dcf877"
    sha256 x86_64_linux:   "71517024181695b5103200682a331fc57964924b965c74a76b920b3e828bc98d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

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
