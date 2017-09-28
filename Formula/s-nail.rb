class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.4.tar.gz"
  sha256 "d5eee1875fe065739c16f9f8aab28cb08f3c349c579016a238e8a9e4f237739d"

  bottle do
    sha256 "bab3491cd174beab7597ac7009237def73badd8e0b403712d1970f1c7c6a2978" => :high_sierra
    sha256 "a60e73ba770df3fc445e4d08930c44f6754e144a605cd6e359566dc3f37b2533" => :sierra
    sha256 "ae1b9a1f45d5719dd2aaf3eeddee2391b86dc0691f4d4aadbd5f79f829ef8b91" => :el_capitan
    sha256 "d8241de6c64e399204671dc5b11018c3fdb3e08d55a11b73f401567d84f92155" => :yosemite
  end

  depends_on "libidn"
  depends_on "openssl"

  def install
    system "make", "OPT_AUTOCC=no",
                   "CC=#{ENV.cc}",
                   "cc_maxtopt=1",
                   "OPT_NOMEMBDBG=1",
                   "C_INCLUDE_PATH=#{Formula["openssl"].opt_include}",
                   "LDFLAGS=-L#{Formula["openssl"].opt_lib}",
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

    expected = <<-EOS.undent
      From reproducible_build #{date1.chomp}
      Date: #{date2.chomp}
      To:
      User-Agent: s-nail reproducible_build

      Hello oh you Hammer2!
    EOS

    input = "Hello oh you Hammer2!\n"
    output = pipe_output("#{bin}/s-nail -#:/ -Sexpandaddr -", input, 0)
    assert_equal expected, output.chomp
  end
end
