class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.3.1.tar.gz"
  sha256 "1cfd1e041d722c51984c7190ab6c6e395ae8f3632b2f34b9dfe3cba85926dabc"

  bottle do
    cellar :any_skip_relocation
    sha256 "12cde8b7c6129e6562d62f1ca0ae286785d3422d0701e371c5711e79e924b07e" => :el_capitan
    sha256 "c62d7f9b00acc90b3f72cdd14630c954b41f1c2ec767f2e42ca6604fb18c119c" => :yosemite
    sha256 "c2ac32b2ea53eb20d34988385fa361e65566efbb5847b80d21d454fc6cd98353" => :mavericks
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
    pipe_output "#{bin}/sngrep -I #{test_fixtures("test.pcap")}", "Q"
  end
end
