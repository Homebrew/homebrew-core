class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.036.tar.gz"
  sha256 "4199964882d56cf6a19ce80c6a297ebe3b0c35ea81106cd4f722342594337c47"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "51abe3f812ae2f799bdd1d179d6ad7aa7d717f858ca34e23627f0e2fd0374c2e"
    sha256 arm64_sonoma:  "ac507af48c3423d27487a9ed8b46afd4ce938bd6e1ed3f5a9d7c1e590b463f83"
    sha256 arm64_ventura: "8c61f1dd2a56a82465ac568ea37e90571e06b3717b08ed703171412ce5e41f52"
    sha256 sonoma:        "7c8f743ef144def9eec8b33062c47f751f5532324d361a5300db710e620a9966"
    sha256 ventura:       "57c53cd9064b9c9f9a8fa59d6dbf4b136e22cfb5fa075ac5d387ae3ae8fa328e"
    sha256 arm64_linux:   "199e15ff7f4201db378b0a6fa71478e2106e7d998c45a6c9812a4ce9dacae153"
    sha256 x86_64_linux:  "7a1b016d70892e80ed64e24fa3148ce42edf59568bb779fb8e4e11c7db38324e"
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
