class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.002.tar.gz"
  sha256 "72d68469fc1262e6288d099062b960a2f65e9425bdb546cba141a2507decd951"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "c04c58b6d86b02df1e878d6ee889600a406f639fc3ceae334ca0d118bb4caf2e"
    sha256 arm64_monterey: "cec176513d3bb689ae84f4201825fd1bbaa1294d33b654e04833d2f57044ed30"
    sha256 arm64_big_sur:  "91b0279e48bc38f89928fd02fada9f0fcd89bccf7b6d1c944dd5106a92c32c28"
    sha256 ventura:        "a3bb98befc539edefa7219c970a1f704ed8e81a96465194f3edbc1327c2c48bf"
    sha256 monterey:       "49cf2ec7dc6c68e91c8788b3a93ce55002cf44005139441c381a14ce1859039d"
    sha256 big_sur:        "596d5d599a9c6f0481fedfa10d5062e50d16801a4c32baedf462fc0dec88b3a9"
    sha256 catalina:       "d84997d31523118754f06202d8627ace7d4ac9ec422ab779b0364c0f1b6274e2"
    sha256 x86_64_linux:   "7f34ecb6d032f90cdff80f504b7ca1b3d38062a74bdbb6399b7c7909d418a41f"
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
