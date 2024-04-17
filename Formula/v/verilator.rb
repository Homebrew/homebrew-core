class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.024.tar.gz"
  sha256 "88b04c953e7165c670d6a700f202cef99c746a0867b4e2efe1d7ea789dee35f3"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "fbdc267ceac2f190c7b3249345da85810836273a4bb070f5f676671ed112ed45"
    sha256 arm64_ventura:  "b74af17f33c1559fd9ba7105fc01080b0411b9e35cd85059b1d62254c8962d1d"
    sha256 arm64_monterey: "4ca78b08eb941000447abd2cc209084f6db17e32ddd0e23f9f4703bc5d1c6d6c"
    sha256 sonoma:         "6b5a02e3c2c590de7050d901673dda556c1bca2a7dd207d2a5cc0f46c3202b3c"
    sha256 ventura:        "2422e3ab02e2bff78f17e6055e37517e57289a0a806cf6dc4a267429dafb7b9e"
    sha256 monterey:       "3f22efeb8bf7911a398f7b8d281ce84970ece724c0c98d13b1450c06ebadae5e"
    sha256 x86_64_linux:   "050aac378cfece87d8619d7ed2b84a7b44c2734ae2a828f79266ec39f69c2715"
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
