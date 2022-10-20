class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.24.tar.xz"
  sha256 "2714d6b8fb2af3b363fc7c79b76d058753716345d1b6ebcd8870ecd0e4f7ef8c"
  license all_of: [
    "BSD-2-Clause", # file-dotlock.h
    "BSD-3-Clause",
    "BSD-4-Clause",
    "ISC",
    "HPND-sell-variant", # GSSAPI code
    "RSA-MD", # MD5 code
  ]
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?s-nail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e3fb2f1ca5f3d34113dd5a7bd1b522675dc6f37c0c3280d8a8473690d691ab07"
    sha256 arm64_big_sur:  "0379b8cbc70eb8dc659d0af3713d23b306d42b2a150180eb403ce49509fa1ea5"
    sha256 monterey:       "997aaf6c68ace33c677e89c7de50c75fb8a2a9d1c768cda79d5147c7fb1de70e"
    sha256 big_sur:        "e54132e6af33629def0c0d3982205e0d3da4f2605be5a4b8443361de66d66159"
    sha256 catalina:       "affc68fc50f6079a85bdb6f23c54f795c9d1e57ac9c681913d85e3fc32eafe3d"
    sha256 x86_64_linux:   "bc6d7e78241ea5f8c869094ae74d37b092739e4d7d230888dfbdea7443a29642"
  end

  depends_on "libidn2"
  depends_on "openssl@3"

  def install
    system "make", "CC=#{ENV.cc}",
                   "C_INCLUDE_PATH=#{Formula["openssl@3"].opt_include}",
                   "LDFLAGS=-L#{Formula["openssl@3"].opt_lib}",
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
