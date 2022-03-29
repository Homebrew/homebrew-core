class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.24.tar.xz"
  sha256 "2714d6b8fb2af3b363fc7c79b76d058753716345d1b6ebcd8870ecd0e4f7ef8c"

  livecheck do
    url :homepage
    regex(/href=.*?s-nail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c76c42e8a887cf6ab33dbcecfd0644c6bc6aef38e27234bdf97e56aac6cd5372"
    sha256 arm64_big_sur:  "f3124f53d46be06a975bd71b9ddebb1eead0104094a32c97e55a8e6f0b3cc635"
    sha256 monterey:       "4d68b331ebc8b46aad429e3e91adc5009ee9ea936467979c2744b24b5304b35d"
    sha256 big_sur:        "60c960dbe634d90101cd9c1fb9efc6119ae896a9ed8387592cf9300b6ac81573"
    sha256 catalina:       "7eebdbe58288d603c2f584e961839fd233437c887b1e3bcd0f200c7f6a3436a5"
    sha256 x86_64_linux:   "1783d8ab84a3d696f709685f91dff33cc1decbc5424271d9f2adc0f39e43aeef"
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
    timestamp = 844_221_007
    ENV["SOURCE_DATE_EPOCH"] = timestamp.to_s

    date1 = Time.at(timestamp).strftime("%a %b %e %T %Y")
    date2 = Time.at(timestamp).strftime("%a, %d %b %Y %T %z")

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
