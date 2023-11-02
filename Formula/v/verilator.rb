class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v5.018.tar.gz"
  sha256 "8b544273eedee379e3c1a3bb849e14c754c9b5035d61ad03acdf3963092ba6c0"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  head "https://github.com/verilator/verilator.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b47c7c591fbd98cde34877623e03c4a6c21f0c11b5cba4e05d507ae4856db827"
    sha256 arm64_ventura:  "771dca8bb5f254ade51cc9ff2fbc43d056cbe25af62cedfa20cb61b7354462fb"
    sha256 arm64_monterey: "1aaa10214a83b76a414d75f74d5840881e209553aa0a435af7ef92f3ac2c656d"
    sha256 sonoma:         "143c245daaa629629da0433db91ee700546e282ad3de6cd221e2d82a2bb4fe9f"
    sha256 ventura:        "f0a6048e4a58c7c08b58fc04a3c7c891b4d6b7623b30f3ceda3547c7ca4e2191"
    sha256 monterey:       "0cdf4d00c49a7cb5020e8d06bd7ac8e0ab03ef4732998c435b933fdfc89d7da2"
    sha256 x86_64_linux:   "fe6638a6b8458630c0b73776fe9e9f949d8dc12992e112f7d6971fbf65b645f1"
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
