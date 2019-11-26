class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/0.7/samurai-0.7.tar.gz"
  sha256 "e079e8de3b07ba0f1fffe2dff31c1fcb3be357c523abc6937108635a081a11f0"
  head "https://github.com/michaelforney/samurai.git"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"build.ninja").write("rule cc\n  command = cc $in -o $out\nbuild foo: cc foo.c\n")
    (testpath/"foo.c").write("int main() {}")
    system bin/"samu"
  end
end
