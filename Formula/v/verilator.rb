class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.050.tar.gz"
  sha256 "ec6723f30c1798b1fbbbed97364f09c431fb4875577c314f37240e99b60a4a04"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "161b3a7a2574d1f48d129b17962aba0844a857c7dab504f803194daa96ec5d51"
    sha256 arm64_sequoia: "bf89e54c27bb084960b549e334b7bf0b9e38726701dbfce0fe94642451ea9a98"
    sha256 arm64_sonoma:  "deeb1c3acfca928f4c07d17fba8d7199347a0965fd306aff4a9b61360e7fa78d"
    sha256 sonoma:        "9218b8f3b45df21c2bd5ef58312aa1f62374f70e07550de737e01634361ea41e"
    sha256 arm64_linux:   "a2fb57b8b5364b4a170b8492c2abb25b9365fdb71cd98e57a8e621675624b5eb"
    sha256 x86_64_linux:  "e055f56393be5bb6163e7af67dad53f6a1846bbcc285bb1aff1348d70bc4c686"
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
