class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.16.tar.gz"
  sha256 "ead76fdfe62ab8af0fdb0ddad9f8b84197aab1881ed15eb2fa654572a8cbbeed"

  bottle do
    sha256 "8cd2950a0266e43cd66c38725c2f5371748bc226f4dccf844e62be5c79d40d70" => :catalina
    sha256 "16b83d9d1e07cccdc3eaf531a67a01a58b0215d3ff61877411da07eb2beae781" => :mojave
    sha256 "bea96ae81b5874ec3bf57b99d66a6452ec23e9ac2ccf359888fde9b32122e93e" => :high_sierra
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
