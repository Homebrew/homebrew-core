class WoboqCodebrowser < Formula
  desc "Generate HTML from C++ Code"
  homepage "https://code.woboq.org/"
  url "https://github.com/woboq/woboq_codebrowser/archive/2.1.tar.gz"
  sha256 "f7c803260a9a79405c4c2c561443c49702811f38dcf1081238ef024a6654caa0"
  revision 1

  bottle do
    cellar :any
    sha256 "fe58745b371aafb698e307687c5969b1d71d07dfdf5d289514e4b7eba7411afd" => :high_sierra
    sha256 "9a2054efa633879136fa0d29902d51644c95ac8b94b2713d72cbc533fb18da07" => :sierra
    sha256 "2543a57c487d2892f95536246c5bf53959cf1e124bfa10128637bdee7e38e2f2" => :el_capitan
    sha256 "154a9954e7af0693a08a5d79f52aec1a41f32ea2cbd97f5ec97de50122f35c89" => :yosemite
  end

  depends_on "llvm"
  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DLLVM_CONFIG_EXECUTABLE=#{Formula["llvm"].opt_bin}/llvm-config", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", *std_cmake_args
    system "make"
    bin.install "indexgenerator/codebrowser_indexgenerator", "generator/codebrowser_generator"
    prefix.install "data"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
      printf(\"hi!\");
      }
    EOS
    system "#{bin}/codebrowser_generator", "-o=#{Dir.pwd}", "-p", "test:#{Dir.pwd}", "#{Dir.pwd}/test.c", "--", "clang", "#{Dir.pwd}/test.c"
    assert_predicate testpath/"test/test.c.html", :exist?
    assert_predicate testpath/"refs/printf", :exist?
    assert_predicate testpath/"include/sys/stdio.h.html", :exist?
    assert_predicate testpath/"fnSearch", :exist?
    assert_predicate testpath/"fileIndex", :exist?
  end
end
