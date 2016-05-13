class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.3.1.tar.gz"
  sha256 "1cfd1e041d722c51984c7190ab6c6e395ae8f3632b2f34b9dfe3cba85926dabc"

  bottle do
    cellar :any_skip_relocation
    sha256 "13b6e49fd6544efef8d064f1f727b554362460ddf3ddb8f5b09ca3f7dc5e8c46" => :el_capitan
    sha256 "29c33c51721537406e6ba9765f773682c41698c022f2d609bc222630040e4a70" => :yosemite
    sha256 "ced61e1c9760359edf8e63983c68b9513dd68d4aa647559146336dda0dbda1e6" => :mavericks
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
