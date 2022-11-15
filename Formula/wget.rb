class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.21.3.tar.gz"
  sha256 "5726bb8bc5ca0f6dc7110f6416e4bb7019e2d2ff5bf93d1ca2ffcc6656f220e5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "fb2b2297226438cf2e9af9f1cf94f450730fc515eace8e21dd2db03700e77629"
    sha256 arm64_monterey: "fc83eec77acee50d2d7ce3bb0cca08d80acccc148e909921de42e57dd5fc7f3d"
    sha256 arm64_big_sur:  "a0c491ae7de2b722320efa94704567e36f3a0bd04bd946b1431ecbd1bcbfb899"
    sha256 ventura:        "e7c2473d1ad12f24fcfa2a2de2eea915e478f5b0204c153daa00b7d3f440b7ab"
    sha256 monterey:       "aa706c58ae7e97abf91be56e785335aff058c431f9973dffac06aacbea558497"
    sha256 big_sur:        "b90e0d7a4319ccdb18ee0c2ed097e9cddeeceaaf70dc0a785d96b4ba69dbeb54"
    sha256 catalina:       "2aadef5aae81ecdd7e28bc9a776adcf0eaa393edae904e0c69740a442b7a3e69"
    sha256 x86_64_linux:   "b6f20b1f4da03b9ee6a42f9305ee015eae7f80afea198e405c0b775eb2333de1"
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
