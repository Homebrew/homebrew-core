class SNail < Formula
  desc "Fork of Heirloom mailx"
  homepage "https://www.sdaoden.eu/code.html"
  url "https://www.sdaoden.eu/downloads/s-nail-14.9.14.tar.gz"
  sha256 "f0e3275274c93f3756fba6c58ca53f05b9fa2f89badb8678608b372d93ea510c"

  bottle do
    sha256 "085d62a87a43193342aa119102e4b9fa21b657291dfdb85c33fd3ae86c925366" => :mojave
    sha256 "7fb3dab8b51b774594041bb9d3fc3aca7e201d434ccdf3d8c105f31b0fec596e" => :high_sierra
    sha256 "8bcf3df7d55e3542cc4abdfb6c2dc3000a0db1a3a68086eca6f3f742e02104f9" => :sierra
  end

  depends_on "awk" => :build
  depends_on "libidn"
  depends_on "openssl"

  def install
    system "make", "CC=#{ENV.cc}",
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
