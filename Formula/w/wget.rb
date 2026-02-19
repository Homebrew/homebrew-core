class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftpmirror.gnu.org/gnu/wget/wget-1.25.0.tar.gz"
  sha256 "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "03be72d23a113a3273245b3e071667b611ea5d81dab6f52e995a84420d0ed734"
    sha256 arm64_sequoia: "d620e085be7df7e93c7a8e6dc98e71b7a2faedbb40e83daae9b823374ee9b09e"
    sha256 arm64_sonoma:  "0611b16c2d24332fbb48cf1d75717b3ac3fc579a6ddac33ee1acaa791ff12e8e"
    sha256 sonoma:        "91995d4d44951e981c36879505e8e294d15e46bbd3ef3965caf94d55424e165b"
    sha256 arm64_linux:   "6c291dba1e71dcfada741192dbf78790c60488d927fa15c82f4bd0901edfa014"
    sha256 x86_64_linux:  "09603bb2a51e4bdc94a9f4f3e66442ef6e401a2a2d244213066c58cceb686f95"
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@3"].opt_prefix}",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl",
                          "--without-included-regex"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", File::NULL, "https://google.com"
  end
end
