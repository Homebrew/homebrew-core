class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.046.tar.gz"
  sha256 "002bc6d92b203eb8b4612e1d198d8108517d4ec9859e131ef328015352fe6d0c"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "f3a956267b2cd69b966546a4c23989060e0026606f927791bf2bdb2d33163146"
    sha256 arm64_sequoia: "666b8acb5a2919edf5d27b15aa848687fc9c057c2cf31960dc37d7cd19fe60e3"
    sha256 arm64_sonoma:  "f84e82a69606fe9c2f475ad3220c2f585452730fe53a4fd414b32f15400ab0cf"
    sha256 sonoma:        "1df77d3bb9fcaf7473e094cf9067a1f9583a2983e8fa345798dcd09842b4b212"
    sha256 arm64_linux:   "9fd6162a1f6e848a5dd21351a12ddcaf4a5fa2b2e80fdf1b27518a2462fa3fe6"
    sha256 x86_64_linux:  "9daca86c4423b677b749c578b55ba1d29c194aad2313b4f7a6b312e1b161bf7a"
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
