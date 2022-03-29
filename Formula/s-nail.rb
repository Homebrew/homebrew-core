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
    sha256 arm64_monterey: "c5ace160fdc2671c6a1c52ea2760e8f614c9a690ae176b7fdb20c75d59e81c60"
    sha256 arm64_big_sur:  "15b9e3df58b3e03c15e04956712a79b24741aeb0d123bb8d9dd1102ca0a13e5c"
    sha256 monterey:       "ae61db0f36b0994a31987e3f458fd71065a9bc80960307259eda7181f5126ba2"
    sha256 big_sur:        "1d8cc34a179d0a8644db640370e1519c19eb6283c2eff81828d6a2116fa7ed1d"
    sha256 catalina:       "1843b6d24d7f7b1a7723a140bf8c85a810324ef7adb0b1020e8201bd29283914"
    sha256 x86_64_linux:   "0ec52dce52c2c2cd9e606b969b06f6fd3b71b15250b5acd05187971c820ebef6"
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
