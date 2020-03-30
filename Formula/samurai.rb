class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.1/samurai-1.1.tar.gz"
  sha256 "cb3ce624f26eb6f0ec0118a02b8f5f7953c3b644e229f50043698fc458f2c98e"
  head "https://github.com/michaelforney/samurai.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a997a0a4b6ccb973e67437051da34f472e94b44a7a92ca4bb0ce118b8c6b16a" => :catalina
    sha256 "7ad83e96a4948e1f70db355263278685739241bc2dfd2aa4bb653f4375d4d6ee" => :mojave
    sha256 "2844980fc09ec69501ef2868b2805ad411abd559bd30e9e998b08a94cb5d415c" => :high_sierra
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
