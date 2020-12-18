class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.2/samurai-1.2.tar.gz"
  sha256 "3b8cf51548dfc49b7efe035e191ff5e1963ebc4fe8f6064a5eefc5343eaf78a5"
  license "Apache-2.0"
  head "https://github.com/michaelforney/samurai.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "070b95f4b8998f10f22e429499f77b885de00d01deff3e2a596501fd2cafe566" => :big_sur
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
