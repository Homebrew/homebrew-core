class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.0/samurai-1.0.tar.gz"
  sha256 "55c73da66b5b8af8b6e26e74b55b3a9f06b763547fe6d0a6206dae68274a1438"
  head "https://github.com/michaelforney/samurai.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a87ae50760da90b1e6c90cbd1ed02668ffb8fb5caf0204140cbb8979da939c1" => :catalina
    sha256 "6f1466c677e072d7951186addb8f10c2c9982e304f7e02e18a66c6b8614f4677" => :mojave
    sha256 "8c449b4e0f2bf0e14491de294221a5f8135db8cb2392aebd24ae6f72deba1405" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      rule cc
        command = #{ENV.cc} $in -o $out
      build hello: cc hello.c
    EOS
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"samu"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
