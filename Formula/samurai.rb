class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.0/samurai-1.0.tar.gz"
  sha256 "55c73da66b5b8af8b6e26e74b55b3a9f06b763547fe6d0a6206dae68274a1438"
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
