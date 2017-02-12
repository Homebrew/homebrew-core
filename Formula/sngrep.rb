class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.2.tar.gz"
  sha256 "30fbfb4f90ed8805194b39683a8a2ed465776ffd60df4482bd029d63b316b3f1"

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
