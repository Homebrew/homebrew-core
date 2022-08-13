class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.224.tar.gz"
  sha256 "010ff2b5c76d4dbc2ed4a3278a5599ba35c8ed4c05690e57296d6b281591367b"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  revision 1

  bottle do
    sha256 arm64_monterey: "0f392a05260a1d258e671cc6e384a9321735489733a33a4576ce17a511009132"
    sha256 arm64_big_sur:  "ae6b2b5cdb712a50df941fac529646c651431644025add1a065ed6f673ec100d"
    sha256 monterey:       "4432deac82c07067bb80378b050c98420f25fbea08c59fcbe46f1b70f46e0131"
    sha256 big_sur:        "7f2ae75b4ac1c9ecdf1317f2abeb8c701cdce091abfb9045dd1979df4f6f2fdb"
    sha256 catalina:       "cf2bab6f0013a54bb38e94c100ef41ee9bddbbe1c456bbcee3b50a95945de6f7"
    sha256 x86_64_linux:   "174147ec666a24525913cd9c30249bea5b6741760c8e76507ee5cd21e199b653"
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

  def post_install
    return if OS.mac?

    # Ensure the hard-coded versioned `gcc` reference does not go stale.
    ohai "Fixing up GCC references..."
    gcc_version = Formula["gcc"].any_installed_version.major
    inreplace(pkgshare/"include/verilated.mk") do |s|
      s.change_make_var! "CXX", "g++-#{gcc_version}"
      s.change_make_var! "LINK", "g++-#{gcc_version}"
    end
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
