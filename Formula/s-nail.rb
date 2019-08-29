class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.15.tar.gz"
  sha256 "4c4bb1dae0fd6edabf1d268ac6a476de9aab3c15b4bbe2141549a11dbf2bae73"
  revision 1

  bottle do
    sha256 "430e096643d36fb5a237c20e26969cc5d378b843ac9bc7fef327caa9668966d8" => :mojave
    sha256 "7dd8b10f7cfa18dd92c27334c9ed05375350a71c4c3a26f416a44475b8f30383" => :high_sierra
    sha256 "9f11039e29af17bee338ff41e42fdaa4b4ab7fe48abd6e2ee512e42eb9a8fe4f" => :sierra
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
