class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.028.tar.gz"
  sha256 "02d4b6f34754b46a97cfd70f5fcbc9b730bd1f0a24c3fc37223397778fcb142c"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "86d5089dbc7b6fda7be55c3660990ab0e735ca5236fe2eb9df3382d1d86ed299"
    sha256 arm64_sonoma:   "3c10f1aae874605da7c4a4c0ec14796ee5b6777b063cd8a0f48822d7009a721b"
    sha256 arm64_ventura:  "5f9002c993fe84421f2a4c571b4fab5d39de309adcea37d3871fb6376e2f6dcc"
    sha256 arm64_monterey: "19fb0e165de3619a24042e6b0f65e95f431a419f4998fd94920d5662e1179e60"
    sha256 sonoma:         "9743a9f0330921a39d8998d53c035c321f61546984b3c0b31923d359fc26d6e1"
    sha256 ventura:        "feef2a655441433628976ea8b67e8ab95f37d63c492ee3ed61f72f44388ac625"
    sha256 monterey:       "b3e4ed2ad6fbe4e1e8719533fc0e12031c16e59a3ce2e0bb5f7e49993077fb47"
    sha256 x86_64_linux:   "6b2f9b5dee679f685b6f7e858a09e56a8ed521859aeaddd2550f563c84a8473f"
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
