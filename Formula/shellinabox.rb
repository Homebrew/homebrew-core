class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.20.tar.gz"
  sha256 "27a5ec6c3439f87aee238c47cc56e7357a6249e5ca9ed0f044f0057ef389d81e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "be4a272fb621880a3357ec3661eb9e455c965200bcaa338a07a1610a651c9f3a" => :mojave
    sha256 "941b62ffa692c9b233ed65803a4572d0012cd925971abd1e529d256566dcc05a" => :sierra
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
