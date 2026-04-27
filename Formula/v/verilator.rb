class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.048.tar.gz"
  sha256 "02d934b3f972c6d9b792350634d81eadfc9e61f347e3f3bdcaad40960b9fcb53"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "9fb61111d7b9ae66d961f1875c6983a0f38ff7619f19ad1f16f7f198ad5705c6"
    sha256 arm64_sequoia: "cb23cc4947b47422a4614b81c70fbb01a86d011196836ac2cb48309ef0feb8f2"
    sha256 arm64_sonoma:  "1f8051b293aedb848fbc54fb8ae793eed860d4d40d7b599db32253fa557bc81c"
    sha256 sonoma:        "2429db724212e771a2a617f824813b298e5a8a121dbeb19d4a3673f4da62e225"
    sha256 arm64_linux:   "cd5ca5996375aea4b76d6694ce976f0e6e8219163d7e546988f6aa778ca2f2fe"
    sha256 x86_64_linux:  "4428bc9242a2b9a0356b1b93a6693d8610e952bf5440c261112b582340a4bc10"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"
  uses_from_macos "python"

  skip_clean "bin" # Allows perl scripts to keep their executable flag

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
