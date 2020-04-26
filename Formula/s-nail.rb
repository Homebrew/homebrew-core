class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.19.tar.xz"
  sha256 "84f249a233a4592cf0c0bda9644c5b2d12e63a4807c0e292c13ef5068d3ca2bd"

  bottle do
    sha256 "7564c78f2a5fff5b8c79dcc729a41512784deee559c296fedd42c9c7ba04a05c" => :catalina
    sha256 "480b7f457b5c13ee346bdfe44b48cf52cdb6fa8076d4d916a04f1d61647664e4" => :mojave
    sha256 "96cd078e3c3697e1fb23dd07322a137a146f1523016ff0a02fae89639b058681" => :high_sierra
  end

  depends_on "awk" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  def install
    system "make", "CC=#{ENV.cc}",
                   "C_INCLUDE_PATH=#{Formula["openssl@1.1"].opt_include}",
                   "LDFLAGS=-L#{Formula["openssl@1.1"].opt_lib}",
                   "VAL_PREFIX=#{prefix}",
                   "OPT_DOTLOCK=no",
                   "config"
    system "make", "build"
    system "make", "install"
  end

  test do
    ENV["SOURCE_DATE_EPOCH"] = "844221007"

    date1 = Utils.popen_read("date", "-r", "844221007", "+%a %b %e %T %Y")
    date2 = Utils.popen_read("date", "-r", "844221007", "+%a, %d %b %Y %T %z")

    expected = <<~EOS
      From reproducible_build #{date1.chomp}
      Date: #{date2.chomp}
      User-Agent: s-nail reproducible_build

      Hello oh you Hammer2!
    EOS

    input = "Hello oh you Hammer2!\n"
    output = pipe_output("#{bin}/s-nail -#:/ -Sexpandaddr -", input, 0)
    assert_equal expected, output.chomp
  end
end
