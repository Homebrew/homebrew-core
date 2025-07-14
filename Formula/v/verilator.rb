class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.038.tar.gz"
  sha256 "f8c03105224fa034095ba6c8a06443f61f6f59e1d72f76b718f89060e905a0d4"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b632565cd681551708b345d190357db97a964a20bd5eac2e18db5ca08cf89640"
    sha256 arm64_sonoma:  "50546be0d9f2869306a1ae20c6ab24150eb0056a0bdf30f9d57c2789c3ade21b"
    sha256 arm64_ventura: "4266406f8102df205f54ce72a922532bba41d992f2b9d3f21a4428a374bb0d61"
    sha256 sonoma:        "8162d41874319b53cce4dec0a3b0f30cfe80bc8170f163e354138ce4ab15dc71"
    sha256 ventura:       "efcfd000fb97584e50f686fb2a4baf5466ff32f0f68a1de6e8f87d7c4e8961a3"
    sha256 arm64_linux:   "dfb62cc4203a70a7443f97806f4e4d60af109a5b8de2223296477a3482219428"
    sha256 x86_64_linux:  "7c1c97a7a994e6f984f578f834ba4b030509e699e87aec7e55940d02e9ce0190"
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
