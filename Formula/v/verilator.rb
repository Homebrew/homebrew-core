class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.016.tar.gz"
  sha256 "66fc36f65033e5ec904481dd3d0df56500e90c0bfca23b2ae21b4a8d39e05ef1"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "940ed2fe9e87d0c291c806fc9df1cabee78d1ca7735102f2abaf39e251f3be65"
    sha256 arm64_ventura:  "6a376cb8788f2cad4a0a23e6bad07310531d59cc526a341c8fece066b91ab3f5"
    sha256 arm64_monterey: "0a4726a82573f02a01880814d1ca0ede419a49ca4a2ce25648e62b8bc10fc759"
    sha256 arm64_big_sur:  "6b0cbcc3c49543b3870d629b6e765ccf3e459b3add1eb0017a788e75989bc315"
    sha256 sonoma:         "f4f1545c8e8ae4ab86c33e60f9527defe0c6b5ed94f7bc4f11584eb7a8964b23"
    sha256 ventura:        "f4011ed6f39f200cd60c50e2fc0ece4584ce6dc42a362f561454c1fe01753534"
    sha256 monterey:       "d8547e788ea1d4cfef5534d1068ad394fe02489c3db5f97b717a67f28bde79e7"
    sha256 big_sur:        "ad60eff72dbbaa9f73b5b893f462dd455d69e05aa12ee200b49f17121314e8d6"
    sha256 x86_64_linux:   "3e2a65f36c594a32fc5b60f36548ccb92f962ba28ccb2e6d3f59eb504d2e1947"
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
