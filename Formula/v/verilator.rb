class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.034.tar.gz"
  sha256 "002da98e316ca6eee40407f5deb7d7c43a0788847d39c90d4d31ddbbc03020e8"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "dca0edbd6258be4bf362fae84bb4e16259178f4a5a4e3c6e229bd95cda45dec9"
    sha256 arm64_sonoma:  "e1640e56e296c3468a0fcb687ec3eacef9098230ead2144469a7def51bc5ea3d"
    sha256 arm64_ventura: "ebe5c705e55516e505b073c7b8c88c3d22990c85efc8fd894373812d1afb09ff"
    sha256 sonoma:        "224d809e313b145c1b67ccd16bda1e4cd2f1cdd6a906eef087a080a6447634c0"
    sha256 ventura:       "e6c7b946da8d9c392ecfe3a12e60603a311c6c1e1909de900762524d5a81bc76"
    sha256 arm64_linux:   "e73948593c34d2af78bce9c77643023d1b8691b2cc205fe2533a0be92c5ca569"
    sha256 x86_64_linux:  "5e3f6b0694a46e5d3f76450b2d66878cd2a14b09af40b920cc3976df9710efa2"
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
