class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-191.tar.bz2"
  sha256 "747bfa86be35dfddf15b6104f94013efc71dd57de0906c340cb9e0717655fd0c"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "e9610eb36215e849dd874b6de531c90b1084fe74346f3ac8865cc478a8171602" => :high_sierra
    sha256 "d39301a6b3cae23feaddb77f08406488229fc0b7864a4084fc9d5839beaac977" => :sierra
    sha256 "2deb3494d9f5a62babe1da3ea00092aded0477f9277ae07cce8ea020234a5caf" => :el_capitan
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
