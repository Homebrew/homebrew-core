class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.14.tar.gz"
  sha256 "f0e3275274c93f3756fba6c58ca53f05b9fa2f89badb8678608b372d93ea510c"

  bottle do
    sha256 "4949c96b5a87abcda782eb8033922e4d7feeaa834b339f3fef486bf9b66ffbcd" => :mojave
    sha256 "7e1320caa4b15e0f3515c18a1633816af1a3fa1fd91b8c2728a7c5d904125787" => :high_sierra
    sha256 "85fc1cc3611245e8da770c28a1d8a3137ed639d08b60c845a892c76eb89d922d" => :sierra
  end

  depends_on "awk" => :build
  depends_on "libidn"
  depends_on "openssl"

  def install
    system "make", "CC=#{ENV.cc}",
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
      User-Agent: s-nail reproducible_build

      Hello oh you Hammer2!
    EOS

    input = "Hello oh you Hammer2!\n"
    output = pipe_output("#{bin}/s-nail -#:/ -Sexpandaddr -", input, 0)
    assert_equal expected, output.chomp
  end
end
