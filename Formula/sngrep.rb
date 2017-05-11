class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.3.tar.gz"
  sha256 "7385ac202de6d6a1feffb2fd514600563133d9dfa7fb47be052de839abcc1d52"

  bottle do
    sha256 "fe8b98d1f20e00953e5da906c3cfafe568307612921a39ab4978dc21c97ffcef" => :sierra
    sha256 "6a6e9e94f1184cbc91f8589f09ff688aa3bd456dc862ecd04de71bef0d17722a" => :el_capitan
    sha256 "65b4d589799e79214563c4a89f9b294a63bb6cc04a1cae363f60846ff6d2d890" => :yosemite
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
