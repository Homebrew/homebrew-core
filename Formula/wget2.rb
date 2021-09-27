class Wget2 < Formula
  desc "Multithreaded metalink/file/website downloader"
  homepage "https://gitlab.com/gnuwget/wget2/"
  url "https://ftp.gnu.org/gnu/wget/wget2-2.0.0.tar.gz"
  sha256 "4fe2fba0abb653ecc1cc180bea7f04212c17e8fe05c85aaac8baeac4cd241544"
  license "GPL-3.0-or-later"

  # NOTE: no optional or recommended
  head do
    url "https://gitlab.com/gnuwget/wget2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lzip" => :build
  end

  # Question: which are required for running and which are build-only?
  # python, tar, texinfo, libz, libiconv, flex are provided by macOS, not writting requirements for Linux now
  # what compress do we need?
  # disable PCRE/PCRE2 since wget did that
  depends_on "brotli" => :build
  depends_on "gettext" => :build
  depends_on "gnutls" => :build # libgnutls
  depends_on "gpgme" => :build # automatic signature verification
  depends_on "libidn2" => :build
  depends_on "libpsl" => :build
  depends_on "nettle" => :build
  depends_on "nghttp2" => :build # HTTP/2 support
  depends_on "pkg-config" => :build # this is just recommended, but Wget use it, so listed
  depends_on "rsync" => :build
  depends_on "xz" => :build
  depends_on "zstd" => :build

  def install
    # bootstrap only for git repo
    if build.head?
      system "./bootstrap", "--skip-po"
      # else
      # linker error if we do not manually link CoreFoundation.framework or libgcrypt
      # this should work, but it didn't. We have to pass to make on command-line
      # ENV["LIBS"] = "-framework CoreFoundation"
    end

    # should we disable libidn, libpsl, or specify ssl to use openssl here?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-doc",
                          "--without-included-regex",
                          "--without-libhsts",
                          "--without-libidn",
                          "--without-libpcre",
                          "--without-libpcre2",
                          "--without-libmicrohttpd"
    if build.head?
      system "make"
    else
      system "make", "LIBS+=-framework CoreFoundation"
    end
    system "make", "install"
  end

  test do
    system bin/"wget2", "-O", "/dev/null", "https://www.example.org/"
  end
end
