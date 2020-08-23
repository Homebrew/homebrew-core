class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.19.tar.xz"
  sha256 "84f249a233a4592cf0c0bda9644c5b2d12e63a4807c0e292c13ef5068d3ca2bd"

  bottle do
    sha256 "8884e726df98985c8e48a64f7ba54396a15c28f4018b9a00c40c05e42eb706c9" => :catalina
    sha256 "a49ee56f5b20d5d40a4c1575032402c51ef1fb111d138aeec0d046ba85600c0d" => :mojave
    sha256 "130bbb9f47467f2b3d5def07ef845eee58a63a2308f13fab71c57ed7d76bb56a" => :high_sierra
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
