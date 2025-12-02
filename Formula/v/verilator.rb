class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.042.tar.gz"
  sha256 "bec14f17de724851b110b698f3bd25e22effaaced7265b26d2bc13075dbfb4bf"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "a62819b0a093e37e976b3cff2d5d4883eadc3ccee4079ac151819ca664599c7c"
    sha256 arm64_sequoia: "7fae027c30a60d38b8a83eea7de31026d1083d5145ee27621257aafad8ac7779"
    sha256 arm64_sonoma:  "1ed60c4ee4c168116fc9290718695920356a700b8e81071add2f2307e1b68d9f"
    sha256 sonoma:        "b6dfccb5d12f77e788431f3b5240086e01f98de73a7014a4fcaaef92802f9279"
    sha256 arm64_linux:   "fc3076ca79ec74585b5d5de5825c70490217de9d72352a903df0d1781de45e58"
    sha256 x86_64_linux:  "1cdc5c08fc08e8e9a4e57276776c1a2d97618fa07f6ff8a6e85050f322bf2aa7"
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
