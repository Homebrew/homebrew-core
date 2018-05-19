class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-196.tar.bz2"
  sha256 "76cf34c891d4c7026fabac32f82ac7137321495f433a32a75145f7fa9ca167ec"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "3102d1f5bd706f58f9071d96d396d21246b8f7867280220f8a3069e36b9472f1" => :high_sierra
    sha256 "af554a088a4f5f7bfcff772c1aa700fcaa84fb15cadd0deef277a62a1cbae760" => :sierra
    sha256 "4e75c4307b05e1a1b9bbfe9edbc0964cb6a9816fe08f6168ed7c77cd552b284f" => :el_capitan
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
