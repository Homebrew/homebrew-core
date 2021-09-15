class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://www.veripool.org/ftp/verilator-4.200.tgz"
  sha256 "773913f4410512a7a51de3d04964766438dc11fc22b213eab5c6c29730df3e36"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  livecheck do
    url "https://github.com/verilator/verilator.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "fe191d41a9bf04fd0536c7564cf1368535e22a0e1245e5c1672bc5e056848181"
    sha256 big_sur:       "cd3937360e860cc0792fbf109cd245d3f48b0cb70d489bfda7db170eb1451e1a"
    sha256 catalina:      "e2825ec3ef68a3344f102d15fd5a5c7915a18bacaf57d9ffdd1dc870e1e152e7"
    sha256 mojave:        "f777b5823ce0aeb7fae25d6f8040d29aebd8f02e02a588b78773f7702bf83e7c"
    sha256 x86_64_linux:  "6eb4b51aeef84c2dc4a6bb9a8becd6ab31fa8ee0d569a1bfc3bc82db1a2c5393"
  end

  head do
    url "https://git.veripool.org/git/verilator", using: :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "python@3.9" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

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
