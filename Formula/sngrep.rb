class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.0.tar.gz"
  sha256 "0be686901773c2648b504137b9bae5e3c7c1373f07ae3f943753cabe3e1b3c51"

  bottle do
    cellar :any_skip_relocation
    sha256 "b24eb110676f862f8f362a6fe56a1b885019ed9f6dbc34540a77e15a70ebea45" => :sierra
    sha256 "80bf467322a973a852b6b84fb6e32bb5d0387303bbd60aab93b3a5ae37ab91e7" => :el_capitan
    sha256 "74ba38790d5263e34c43f8f8c970e610d2a0d514cb3b9ac5a06072e18f00cfce" => :yosemite
    sha256 "6007b4506629bfeb7759b4450d01ac1ff14a75d582c14f1c7568dd9cdf722f95" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/sngrep -I #{test_fixtures("test.pcap")}", "Q\n", 0)
  end
end
