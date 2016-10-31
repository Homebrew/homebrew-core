class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.1.tar.gz"
  sha256 "8a0d29c35ceb612ccca536df31ab3e5fcc7bf957a48d11483c6bd93779be33d2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7793c45e7ffc7135fa36403fdcd47d99540578e0d446d4c7b4032af5fb297338" => :sierra
    sha256 "6258f549be9d991798939980bbacaa563c0207d336db90e3d74063e30e3577eb" => :el_capitan
    sha256 "f9d7cdd161148c4eca5f96d1339a9d2aca66486b5c233ceb4e485266025d831d" => :yosemite
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
