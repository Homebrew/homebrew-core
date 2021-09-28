class Wget2 < Formula
  desc "Multithreaded metalink/file/website downloader"
  homepage "https://gitlab.com/gnuwget/wget2/"
  url "https://ftp.gnu.org/gnu/wget/wget2-2.0.0.tar.gz"
  sha256 "4fe2fba0abb653ecc1cc180bea7f04212c17e8fe05c85aaac8baeac4cd241544"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  # NOTE: no optional or recommended
  head do
    url "https://gitlab.com/gnuwget/wget2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Question: which are required for running and which are build-only?
  # python, tar, texinfo, libz, libiconv, flex are provided by macOS, not writting requirements for Linux now
  # what compress do we need?
  # disable PCRE/PCRE2 since wget did that
  depends_on "pkg-config" => :build # this is just recommended, but Wget use it, so listed
  depends_on "rsync" => :build

  depends_on "brotli"
  depends_on "gettext"
  depends_on "gnutls" # libgnutls
  depends_on "gpgme" # automatic signature verification
  depends_on "libidn2"
  depends_on "libpsl"
  depends_on "lzip"
  depends_on "nettle"
  depends_on "nghttp2" # HTTP/2 support
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-doc",
                          "--without-included-regex",
                          "--without-libhsts",
                          "--without-libidn",
                          "--without-libpcre",
                          "--without-libpcre2",
                          "--without-libmicrohttpd"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"wget2", "-O", "/dev/null", "https://www.example.org/"
  end
end
