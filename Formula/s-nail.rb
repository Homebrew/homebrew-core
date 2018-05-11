class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.10.tar.gz"
  sha256 "87ade7bbeb110250afce8221b2bb553a3d9661327dfca3f622994fb017c49ccb"
  revision 1

  bottle do
    sha256 "08fde68f95086b3121e00dd372e958a76a6b8e70d1e104535fe417a631afa395" => :high_sierra
    sha256 "5df2ce5b56c5ce1eaa280050a41d8b56d46f3c259da55770a0af493bccb6aca0" => :sierra
    sha256 "7cd606ff6ed00c479de05779451f0e3b8398dcae87209f9c375d4e3fd607ad33" => :el_capitan
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

    expected = <<~EOS
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
