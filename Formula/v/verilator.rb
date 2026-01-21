class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.044.tar.gz"
  sha256 "ded2a4a96e3b836ddc9fd5d01127999d981adee4d19133ff819b7129897d801a"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "bd485cc5c1e943c2b6ad0a64030480be106ddf90ce33363f38e3a387e075a310"
    sha256 arm64_sequoia: "03e76169e8eb2d8c9bfb48f015a8cbb89c921ed1f3aa5cebe68f6c39a824685c"
    sha256 arm64_sonoma:  "34fd026a4c3df224916898c78271a6367b751ac13aebf8997a11b9c505018ff3"
    sha256 sonoma:        "a094ca30aa50f7827eb1f59d268ed6d90fcf3c832085c313faa5a816469ca5cd"
    sha256 arm64_linux:   "fcb4b8a664e61b1e4a1ccdc3a182d8d7626be4f617cb0a7fb51b386793560223"
    sha256 x86_64_linux:  "7937574dd4ca9aca5ec4b256a2b30106cac9e5ce6ad9766bafc543d61731164e"
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
