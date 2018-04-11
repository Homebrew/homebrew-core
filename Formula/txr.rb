class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-191.tar.bz2"
  sha256 "747bfa86be35dfddf15b6104f94013efc71dd57de0906c340cb9e0717655fd0c"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "ec194c3dc00f8679691b746c762fa6f20b50fcd71d4ca9c38e788cdab66c24db" => :high_sierra
    sha256 "cc8273b195c2cb742bc4f5fbcc19d6f5dd18aca80ad97956fd14f861e54cd4d5" => :sierra
    sha256 "25d547a352b8d9a847cdb6e7ee884e6aabe5e0f48dd919d1bc61a498c44e1128" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
