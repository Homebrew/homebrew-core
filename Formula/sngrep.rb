class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.3.tar.gz"
  sha256 "7385ac202de6d6a1feffb2fd514600563133d9dfa7fb47be052de839abcc1d52"

  bottle do
    sha256 "08bd1a20db915fe10ab3c945100932353b7587154a9ed0c2064d297a26959cd8" => :sierra
    sha256 "142bfb041ad655637c0ffd97266ba22555821e5c2c0b8efea3724650e22e8d9d" => :el_capitan
    sha256 "77409d150899b54bafebe6ced0472528e7c9b9929e9fb4c219d00bb1582958b2" => :yosemite
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
