class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.2/samurai-1.2.tar.gz"
  sha256 "3b8cf51548dfc49b7efe035e191ff5e1963ebc4fe8f6064a5eefc5343eaf78a5"
  license "Apache-2.0"
  head "https://github.com/michaelforney/samurai.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e3819fa6eb240e781c236528297422575c6c2ae9aa4e38e6ddc7dbac0e25339" => :big_sur
    sha256 "04ca3c9aada344360216791324e673db86948a3eaa2e82a541cb1fd28647b1bf" => :arm64_big_sur
    sha256 "35e183246e80cfe5a6f9b11b12cd2e0c3a754da15b8fb7550b5716de9e219e8d" => :catalina
    sha256 "ef652224d51e64d4e83f921a3870cd9cb4d7dbc315156cb68dd01d30d2d34414" => :mojave
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
