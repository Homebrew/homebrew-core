class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.1.tar.gz"
  sha256 "59ba0bdade9ad135eda581ae4e59a7a9f25e3a4bde6a5419632b31906120e26e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "e9034fc9062d5d28972135be031876672aff18fa945ce37e9c2ee1e2c4287f3a"
    sha256 big_sur:       "e6ea2a50b8196206f7072360e713535bb16fb786c8b5fe23cab05757e0f67b13"
    sha256 catalina:      "88116cb28d6b85e441d1bb9df0a1454b84f8b9d0e8817a5bee0f228acc59e75a"
    sha256 mojave:        "ae4e6f1dc4ecaf2bbed7700e8d64cdc671bf9d6c085ba335f119861fd15956fe"
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-ssl=openssl",
                          "--with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-debug",
                          "--disable-pcre",
                          "--disable-pcre2",
                          "--without-libpsl",
                          "--without-included-regex"
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
