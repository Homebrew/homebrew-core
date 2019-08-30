class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.15.tar.gz"
  sha256 "4c4bb1dae0fd6edabf1d268ac6a476de9aab3c15b4bbe2141549a11dbf2bae73"
  revision 1

  bottle do
    sha256 "a5d0e4ee44f0effe6ea9b12fc319a6dd4e985f3fbb58e5f085b543b67d74d470" => :mojave
    sha256 "41a29df9514b5bc54604f7060e29dcaee590f7f3ed99e5c68b8628e736e75087" => :high_sierra
    sha256 "13a5ac322c72e3a2439a13e7cf287cd8a7f58351072ef225a48775f9c048c9cf" => :sierra
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
