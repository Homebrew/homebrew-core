class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.11.tar.gz"
  sha256 "279202687409b8e7b4f267e178aed1bd4c68b79c01c10b80f07197f2f73d6695"

  bottle do
    sha256 "50017a1a58e325f6cf2bf442e69279334f97a3167160d09ce14803d115fb74ff" => :mojave
    sha256 "39c79b2b08e58b4784fb16bdf8ff6133d8eb3b435bbc8e97e493001a16fd5f4c" => :high_sierra
    sha256 "c1942ec66157c586e6648051d2461ccbd8aaa0b99ec7f4f757c982683c9c08aa" => :sierra
    sha256 "4d137ea6f6ff75f6bd792584aa4d86ead5445f0e5df9c9ed7074d84df3b7fb0f" => :el_capitan
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
      User-Agent: s-nail reproducible_build

      Hello oh you Hammer2!
    EOS

    input = "Hello oh you Hammer2!\n"
    output = pipe_output("#{bin}/s-nail -#:/ -Sexpandaddr -", input, 0)
    assert_equal expected, output.chomp
  end
end
