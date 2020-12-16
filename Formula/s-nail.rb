class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.20.tar.xz"
  sha256 "06aa2418d0b9dead568efb589c3da2e36e0da017c285260db5a2efa8a999e4ea"

  bottle do
    sha256 "6d660c644fb08f0d351a1eaa20d89dc2b6c79691b6b821c1337d824b400e7c7c" => :big_sur
    sha256 "fe903ebf2cad85b35e070e37afa01830a82a64f2d075608ccf000ddeeaa58039" => :catalina
    sha256 "8cedc5aa5ed25d16f386c75cf184e793267bedf5687c1746a3bb5e7588faa2fd" => :mojave
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

    date1 = shell_output("date -r 844221007 '+%a %b %e %T %Y'")
    date2 = shell_output("date -r 844221007 '+%a, %d %b %Y %T %z'")

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
