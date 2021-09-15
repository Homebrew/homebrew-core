class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.22.tar.xz"
  sha256 "e5dfb7d5bcc5d2d1126f2e826569ee0f149aac3f2a8a6b7c23985ffc3a1def0b"

  livecheck do
    url :homepage
    regex(/href=.*?s-nail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "b8bde9083dd42cef197e98608fc9ce2dc69b3d9cf56ff05268c565ba7acdb67b"
    sha256 big_sur:       "20825afa468b7d368b71dfc73314412eb9e6930cecd5794f71b527422e63d28c"
    sha256 catalina:      "e2dd4f1ede94f221fffffce676a2a605edb49235d5bf875e2cad917c9a4d6c73"
    sha256 mojave:        "1c33bcd338bf27c5f7f3a61e9b6a4070a5cf9e9e7cfefd58afe178959dd35f5a"
    sha256 x86_64_linux:  "b3331d1cd2c8856e02fc3ba876530df8538ec52dd5bef29ccfdc88cbbe71fe89"
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
