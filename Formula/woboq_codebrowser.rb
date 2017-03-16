class WoboqCodebrowser < Formula
  desc "Generate HTML from C++ Code"
  homepage "https://code.woboq.org/"
  url "https://github.com/woboq/woboq_codebrowser/archive/2.0.1.tar.gz"
  sha256 "f2ec67bb49415986a4bbef515024009433756c83e14fa84f5acc40c83eec19e6"

  bottle do
    sha256 "61b8336b7118c845ff09ea2d8733a741fe5bf1e08469d474c62ddea3245519e8" => :sierra
    sha256 "503bfd97e11ae244521a501487f4a4d0b48c512550ced9cb29fc5e4fcb355eb7" => :el_capitan
    sha256 "ceec3aed2f4ccf00b27d2676113dde02cc131251745abbfc039e37a8391c52eb" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      int main() {
      printf(\"hi!\");
      }
    EOS
    system "#{bin}/codebrowser_generator", "-o=#{Dir.pwd}", "-p", "test:#{Dir.pwd}", "#{Dir.pwd}/test.c", "--", "clang", "#{Dir.pwd}/test.c"
    assert File.exist? "./test/test.c.html"
    assert File.exist? "./refs/printf"
    assert File.exist? "./include/sys/stdio.h.html"
    assert File.exist? "./fnSearch"
    assert File.exist? "./fileIndex"
  end
end
