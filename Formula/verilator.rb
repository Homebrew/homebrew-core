class Verilator < Formula
  desc "Verilog simulator"
  homepage "https://www.veripool.org/wiki/verilator"
  url "https://github.com/verilator/verilator/archive/refs/tags/v4.224.tar.gz"
  sha256 "010ff2b5c76d4dbc2ed4a3278a5599ba35c8ed4c05690e57296d6b281591367b"
  license any_of: ["LGPL-3.0-only", "Artistic-2.0"]
  revision 1

  bottle do
    sha256 arm64_monterey: "686255a009c570b835da458c87443e30046c3823987ed828a08cb8c6ec480792"
    sha256 arm64_big_sur:  "3434410fec0fd311ac6cc071b4e4afe4bf2347dba9aebc9a716b57e51c267574"
    sha256 monterey:       "815fc7c251037f2fcfc9e546c5547501b38d639c898589ea2280370a5508102a"
    sha256 big_sur:        "22f09955d314f24fc3352c71b5fffda8c402598fdfda5806005320fefa73147c"
    sha256 catalina:       "40058c5b667deec2037f713ab77076509a42316d67b5d8bd0cd52f4fe3eb6374"
    sha256 x86_64_linux:   "cb55ba0cc3b9679c6ca07d98036f139ffb3e8d77c3a55cc4f3afe56b576d1a96"
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

  on_linux do
    depends_on "gcc"
  end

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

  def post_install
    return if OS.mac?

    # Ensure the hard-coded versioned `gcc` reference does not go stale.
    ohai "Fixing up GCC references..."
    gcc_version = Formula["gcc"].any_installed_version.major
    inreplace(pkgshare/"include/verilated.mk") do |s|
      s.change_make_var! "CXX", "g++-#{gcc_version}"
      s.change_make_var! "LINK", "g++-#{gcc_version}"
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
