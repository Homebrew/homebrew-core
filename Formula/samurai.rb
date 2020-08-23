class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.1/samurai-1.1.tar.gz"
  sha256 "cb3ce624f26eb6f0ec0118a02b8f5f7953c3b644e229f50043698fc458f2c98e"
  license "Apache-2.0"
  head "https://github.com/michaelforney/samurai.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef3f56caffb50416e4d708cea0910b1658811464b94697b850760bf6acc70e4a" => :catalina
    sha256 "90d42648667443f8bc1e9de25e221b2c16d8c973bac6cda33bfb1f611893144a" => :mojave
    sha256 "e9c857e0bf7f2713d90d21040ab28431c03fe0e560a17d8dab6a3b4d6c463111" => :high_sierra
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
