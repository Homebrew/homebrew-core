class WoboqCodebrowser < Formula
  desc "Generate HTML from C++ Code"
  homepage "https://code.woboq.org/"
  url "https://github.com/woboq/woboq_codebrowser/archive/2.1.tar.gz"
  sha256 "f7c803260a9a79405c4c2c561443c49702811f38dcf1081238ef024a6654caa0"
  revision 2

  bottle do
    cellar :any
    sha256 "553acd46ed5042664933e571c5507701c0a44fe64066955c7e5771154d63b7b7" => :mojave
    sha256 "540266c775e25379110f82e933649cbf2f2582e6541bbaba57f94fe88da5a4e4" => :high_sierra
    sha256 "e667ed2580d16bfcc1ebfc80669d22b67105625f49190d9e2c965817e6870c22" => :sierra
    sha256 "c04a6cd9fd7102e2ca5858dce5068bbfcede09e3d655e0512a2942d83f5a75e8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    args = std_cmake_args + %W[
      -DLLVM_CONFIG_EXECUTABLE=#{Formula["llvm"].opt_bin}/llvm-config
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    ]
    system "cmake", ".", *args
    system "make"
    bin.install "indexgenerator/codebrowser_indexgenerator",
                "generator/codebrowser_generator"
    prefix.install "data"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
      printf(\"hi!\");
      }
    EOS
    system "#{bin}/codebrowser_generator", "-o=#{testpath}", "-p",
                                           "test:#{testpath}",
                                           "#{testpath}/test.c",
                                           "--", "clang", "#{testpath}/test.c"

    assert_predicate testpath/"test/test.c.html", :exist?
    assert_predicate testpath/"refs/printf", :exist?
    assert_predicate testpath/"include/sys/stdio.h.html", :exist?
    assert_predicate testpath/"fnSearch", :exist?
    assert_predicate testpath/"fileIndex", :exist?
  end
end
