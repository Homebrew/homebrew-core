class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftpmirror.gnu.org/gnu/wget/wget-1.25.0.tar.gz"
  sha256 "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "8cbb5d277cd207e543c9b2e75953e89c7cc89105b2322f3ce652616c5d0f62fe"
    sha256 arm64_sequoia: "a93dd95c5d63036e026b526e000d33fae7fb44d9a8fda5afc89bff112438c6b3"
    sha256 arm64_sonoma:  "4d180cd4ead91a34e2c2672189fc366b87ae86e6caa3acbf4845b272f57c859a"
    sha256 arm64_ventura: "7fce09705a52a2aff61c4bdd81b9d2a1a110539718ded2ad45562254ef0f5c22"
    sha256 sonoma:        "5650778a8e7a60c2dea9412dd21d2f5e8ff4f224dbefbdf54924b99012062edc"
    sha256 ventura:       "78cee523a9b58a7b824b51767935f68c9838e9f673e70d001982858001e766ff"
    sha256 arm64_linux:   "2f06529fc47fa99e9d4a5ebd19f25c046dda236278c7c5979e080ad7e5387236"
    sha256 x86_64_linux:  "ab5f3c1c60bef4e2a4781e9b29af8afb48ead837136c419edd7febdf44b59058"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libunistring"
  end

  on_linux do
    depends_on "util-linux"
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
