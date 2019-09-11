class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0fb5d5bf2e9370f9826ad3326c6c5116837d062346e5526b81ad6bf34b465b3f" => :mojave
    sha256 "6258d7d019bb81204ba0159c3b483bace0137502cc9a5a9dff9f2a5bcf0b4409" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  # Upstream (Debian) patch for OpenSSL 1.1 compatibility
  patch do
    url "https://github.com/shellinabox/shellinabox/pull/467.diff?full_index=1"
    sha256 "3962166490c5769e450e46d40f577bf4042ac593440944f701fd64ee50d607d8"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shellinaboxd", "--version"
  end
end
