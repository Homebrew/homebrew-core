class WoboqCodebrowser < Formula
  desc "Generate HTML from C++ Code"
  homepage "https://code.woboq.org/"
  url "https://github.com/woboq/woboq_codebrowser/archive/2.1.tar.gz"
  sha256 "f7c803260a9a79405c4c2c561443c49702811f38dcf1081238ef024a6654caa0"

  bottle do
    cellar :any
    sha256 "f89367b274491906702004966f4d2f4b2f1f8b7cbc496eca90261dfe8a69dcd8" => :sierra
    sha256 "3bd5cf8c807767b82559d4b278722a24667adb9d5d1a4b9bca653c4f36f05423" => :el_capitan
    sha256 "e54d6d923cc9fb157e04135829edc1882c282f8a1582c272b923ecd5ddd3da0e" => :yosemite
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
