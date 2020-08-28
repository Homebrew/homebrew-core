class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.040.tgz"
  sha256 "6e1574924083922a4eb80ff22eedc866f4ce54e5fd6a34101b6af7aa29e5c0e3"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  livecheck do
    url "https://github.com/verilator/verilator.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "f4f7abca35a5479c05aecdab7cd1a0e693a1e6a731663c175ade7b61dc017d10" => :catalina
    sha256 "a74987a1eea55449a79c828b3c140e16f2c8272eddeb12b2fd3080256ef0cccb" => :mojave
    sha256 "a0305efdbcd821ab55c49bcc3267c4a2a27567b85d1b2a21c001551ef1741d14" => :high_sierra
  end

  head do
    url "https://git.veripool.org/git/verilator", using: :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  skip_clean "bin" # Allows perl scripts to keep their executable flag

  def install
    system "autoconf" if build.head?
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
