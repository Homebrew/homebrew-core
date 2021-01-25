class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.21.tar.xz"
  sha256 "bf21d72531f85b8882c5a583ce96c901104ce0102a287c7ad680ef068c2ceafd"

  bottle do
    sha256 "bcf734125581c0b6bc01846a321145f6aa1838436846c042b12602c70745e5cc" => :big_sur
    sha256 "06306c446dcf62dee3ee196960f68952e6440b0161e4fb40a823c652a1c4638d" => :arm64_big_sur
    sha256 "749f19641e745d458eb70bd5af6cf612b204084706bf286c749ffac466dd3679" => :catalina
    sha256 "699925f22c2a244c74cd9ebe8fc16c786c4a1d3e5084f14187fcbb834f389c69" => :mojave
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
