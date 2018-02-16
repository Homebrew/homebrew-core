class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.7.tar.gz"
  sha256 "0208bb6e3b2c09dd1f592256a98f00ed2a7ccefd00af575e800659c06d604ffc"

  bottle do
    sha256 "f00cbf6352ab97d49ced55a2e17e7b89c31eb5882e6044ad2db42adfabc46485" => :high_sierra
    sha256 "c824a95f5b7c6dca6ec6649acac95861caacec8cecd8af3a05a691ce62f9ca3e" => :sierra
    sha256 "5d4f7d285171464aa57327910fe9e4ef784de54a9e1a519312b2e0a29c5aff0c" => :el_capitan
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
