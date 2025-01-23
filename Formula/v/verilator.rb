class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.032.tar.gz"
  sha256 "5a262564b10be8bdb31ff4fb67d77bcf5f52fc1b4e6c88d5ca3264fb481f1e41"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3612fb39c7d25cf350f8f2007bce3f364630e6e571eabe258b7abc8633236452"
    sha256 arm64_sonoma:  "cba576313468ff895ba287014dd54db630fdc6b82fa1c1f61e3eecede07bb806"
    sha256 arm64_ventura: "64a7a891493f91a770195675ef00411f9851fab5c38091b88947ee33a91a9578"
    sha256 sonoma:        "0fea2b55dbd9861c8e4ecf48b6594c1b3e66de6c01d088a5d20e59eda83a13f6"
    sha256 ventura:       "13b177e4a33d40d0edb8795546d20ec50529c3825bffddc176ab4f8f942cccb1"
    sha256 x86_64_linux:  "ef4f88f802756b5a40507fcfd44c69a63dcdf0ca49a5ce0147075281202685c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina

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
