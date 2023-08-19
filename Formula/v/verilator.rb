class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.014.tar.gz"
  sha256 "36e16c8a7c4b376f88d87411cea6ee68710e6d1382a13faf21f35d65b54df4a7"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "c7e1c43bfdc0a7ed4190ceb982c70e3f1111bdf14bdc28ffcab75e2930678529"
    sha256 arm64_monterey: "2a08514d4611648409375222e9d8e1841f7f799525512c9c90e4a6fca411feb2"
    sha256 arm64_big_sur:  "afab46195a7a9d1186380a49cc769b0f5ffabc236596be89e8f63d0e7262f7d8"
    sha256 ventura:        "bd6c1f2848626ac7d36befa527b86070a72594c22a7ec9bc3acc8ebd4bfe4847"
    sha256 monterey:       "9f95d8f8a9b1ba5e6cb4667e422d4bfee202c85a1986d58d9e55da7e1ef6cbf7"
    sha256 big_sur:        "a25bebc5dddae09f92f1407f478d05b6478f5b5518f0d445163b334cab682af6"
    sha256 x86_64_linux:   "725a96af88e568f4f460c88dabbf967717ef051226d073ecf72558094ace8e07"
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
    ENV.deparallelize if OS.mac?
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
