class Upx < Formula
  desc "Compress/expand executable files"
  homepage "https://upx.github.io/"
  url "https://github.com/upx/upx/releases/download/v3.92/upx-3.92-src.tar.xz"
  mirror "https://fossies.org/linux/privat/upx-3.92-src.tar.bz2"
  sha256 "0378169c342a0f98dc93236deae42f72fda07d0b02d7f51e6147448ee7e77794"
  head "https://github.com/upx/upx.git", :branch => :devel

  bottle do
    cellar :any_skip_relocation
    sha256 "be65bc79a7cb80800e933ac2a39d92fd60c26b8777fe7fe42c0aac0ca0a08d5b" => :el_capitan
    sha256 "e994574f32103ab5ddf4206093ac9733c66e59bac5e2d3104e56e90dc668e0fa" => :yosemite
    sha256 "88d59c54ca8f47a035e9a145a995b74589a9c4ed1524ff5ac91a7a7dbd34df11" => :mavericks
    sha256 "6e715e575ec208612d046de57438fe1568d3b56dc536db7935b2d421d1b0041c" => :mountain_lion
  end

  depends_on "ucl"

  def install
    system "make", "all"
    bin.install "src/upx.out" => "upx"
    man1.install "doc/upx.1"
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "cc", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    system "#{bin}/upx", "-1", "hello-c"
    assert_equal "Hello, world!\n", `./hello-c`

    system "#{bin}/upx", "-d", "hello-c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
