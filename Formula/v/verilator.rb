class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.026.tar.gz"
  sha256 "87fdecf3967007d9ee8c30191ff2476f2a33635d0e0c6e3dbf345cc2f0c50b78"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "373ecba639adda0f1bd50908959949071942780f5d0f61a2632088e65b02d4bc"
    sha256 arm64_ventura:  "314e22fb7b4ace2901296a219eaf371246b141d980897735e1fe2ec59682bdcc"
    sha256 arm64_monterey: "db32bbba379c6ab01e377c9ff8d00b84590c962f1c522ceebc8a0396d72fd434"
    sha256 sonoma:         "5327ae46745289aac4bb24e49fe61e872d86f1352a0deaab2c312cf31bc65033"
    sha256 ventura:        "19723c4eebceaa8de4c080f975678f70789f012f68f89c7ba3f3680587d77a98"
    sha256 monterey:       "a0ea85a0515253664a80f7ac3c01e39818a59b7d89789a72bc6f6e90d4756f41"
    sha256 x86_64_linux:   "b0053c65793301ca1412975345e54b4bd4e55dc45fee3b7ce289db669d2c463c"
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
