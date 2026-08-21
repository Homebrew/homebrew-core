class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftpmirror.gnu.org/gnu/wget/wget-1.25.0.tar.gz"
  sha256 "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "27e15ca14afaaa7c2016bba7a098452cf66d1d8a74330ed6195a0b6ae7a4dada"
    sha256 arm64_sequoia: "aa19cf5de262d5b67631af8288cce233a075c251c68050a1e73699314a911e7b"
    sha256 arm64_sonoma:  "ebac9bd5e93603af8d3dcf3cfed9924f773e0fa5f8a827c12c69ad07cc80a6de"
    sha256 sonoma:        "32e76ca0ef4b26d7022dd1cad7621e8cd9bccca7677b7d4646d30d2fa009f413"
    sha256 arm64_linux:   "f6e698ad339b9d9398f9769ad46ffa999809e9e07ab0e6d9a1537ec136dbaf01"
    sha256 x86_64_linux:  "8f58b44e7482ee12e910df582cf43a4dadb808e4db70bfc760aaf258942652a5"
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "libpsl"
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
                          "--with-libssl-prefix=#{formula_opt_prefix("openssl@3")}",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--with-libpsl",
                          "--without-included-regex"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", File::NULL, "https://google.com"

    # Verify PSL support is built in via libpsl
    assert_match "+psl", shell_output("#{bin}/wget --version")
  end
end
