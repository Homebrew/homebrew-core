class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.226.tar.gz"
  sha256 "70bc941d86e4810253d51aa94898b0802d916ab76296a398f8ceb8798122c9be"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]

  bottle do
    sha256 arm64_monterey: "ef87fc6399d3f6da48ff60b67c1e009202f19c42fb7f1d59737ccc1743c92be2"
    sha256 arm64_big_sur:  "10c1c488e94765f5531281f4dc4fd4640938d1db83947f8c5a55f7db85c6bff2"
    sha256 monterey:       "9dfee8b25d4ba52111c841ef109b0aabd7f27089aaeb5ec689a59fd97b442aa4"
    sha256 big_sur:        "7ff4ff84a34df0c65da91b144aa7a3b0e1194f3960c264d201b3305d77f9abb9"
    sha256 catalina:       "c47ed2b560a824281e2a8af2a4d301556cd2ad4830e9a11c3d5e5fdd365730ea"
    sha256 x86_64_linux:   "bb2b488c700f8bc421a3cc217d018dda191bc2a4201f9b99b8aaf7cbbefa38f2"
  end

  head do
    url "https://github.com/verilator/verilator.git", using: :git
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.10" => :build

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

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
