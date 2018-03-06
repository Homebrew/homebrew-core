class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.9.tar.gz"
  sha256 "cdbd278b634f32df80f22d0a3fc7e59b0d5f3d41a19fef4638efcb6c2d198490"

  bottle do
    sha256 "c8ca7622a2cee89f8db0f3fb33c72b85f791802cefc022a8c7d5577964841512" => :high_sierra
    sha256 "86a62c7ad710d36150e66b29dfbb6f34b1eee25d77c791b1d753d02a3301dbb0" => :sierra
    sha256 "6b56aea3f271578b84ba3fafd7e941e2269f3cbfcfeaa91e415e435334d50177" => :el_capitan
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
