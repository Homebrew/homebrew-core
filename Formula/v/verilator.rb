class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.022.tar.gz"
  sha256 "3c2f5338f4b6ce7e2f47a142401acdd18cbf4c5da06092618d6d036c0afef12d"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "cdbbc21547d6bd630f1084e3de089f806f8cd9a01dc1c21902d3b8a249a01acc"
    sha256 arm64_ventura:  "54dbd46906419c612e9c1d9dd834bbc264acaa5bec368eaeca6295c27b164d68"
    sha256 arm64_monterey: "d447146992ddd831dc3939dadf6e0017b964f68a25f8d09bc1cf7672569af004"
    sha256 sonoma:         "d794010777e190597e399e6027288b42f2982ed1b19fad069cfe9cda0bc6f7e5"
    sha256 ventura:        "8824e57d2d9b8c49a77ee5f4048574ac9b7c8da162061ebf88251990951db6f9"
    sha256 monterey:       "1e6d312e7808ffd8c9faedb0a279d0d134a43a8b8b079ab3b8c98cf3f758037a"
    sha256 x86_64_linux:   "0cbb69277bfcdefef780a639e858533d364b7a59597603327b71f4737681a1fa"
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
