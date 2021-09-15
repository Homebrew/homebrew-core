class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  license "GPL-2.0"
  revision 3
  head "https://github.com/sphinxsearch/sphinx.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_big_sur: "57a2dc9f3c5c40d46785753531e4801a7db0560c11434a10d224efeba3c2c1b2"
    sha256 big_sur:       "bbaebbfc31099a28b528c679a2c7825e218e42d83d04a4b0dc53561e70fcbdca"
    sha256 catalina:      "f3d89ffcd2926373af5a35bb7ae6f16e59074699eeacfb4d358a0dc5742729cc"
    sha256 mojave:        "61f1ae14e253c8c84f0e8a9f3a26833ca4a1da887d97c0df8ecebb6096222546"
    sha256 high_sierra:   "3daf6e565c7c12803c13b6439a872e61335b3b27c06719ca6f8cec93dcd2176e"
    sha256 x86_64_linux:  "3736780f2809b0449953cfb4ed85cc7d65b86e6c5c55aa98186062f8aff81d99"
  end

  depends_on "mysql@5.7"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "manticoresearch", because: "manticoresearch is a fork of sphinx"

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        revision: "9b58e92c965cd7e3208247ace3cc00d173397f3c"
  end

  def install
    resource("stemmer").stage do
      system "make", "dist_libstemmer_c"
      system "tar", "xzf", "dist/libstemmer_c.tgz", "-C", buildpath
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --localstatedir=#{var}
      --with-libstemmer
      --with-mysql
      --without-pgsql
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"searchd", "--help"
  end
end
