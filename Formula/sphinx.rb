class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/sphinxsearch/sphinx.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_monterey: "1b9d46aed9d62eff25aba72b20380e2b03fc04851b9309fbce3ffc071f2760c7"
    sha256 arm64_big_sur:  "57a2dc9f3c5c40d46785753531e4801a7db0560c11434a10d224efeba3c2c1b2"
    sha256 monterey:       "17c8dbbdd7f5abf50a195e72dc3eee1bea414490ecffa97473e8ed99dff90aea"
    sha256 big_sur:        "bbaebbfc31099a28b528c679a2c7825e218e42d83d04a4b0dc53561e70fcbdca"
    sha256 catalina:       "f3d89ffcd2926373af5a35bb7ae6f16e59074699eeacfb4d358a0dc5742729cc"
    sha256 mojave:         "61f1ae14e253c8c84f0e8a9f3a26833ca4a1da887d97c0df8ecebb6096222546"
    sha256 high_sierra:    "3daf6e565c7c12803c13b6439a872e61335b3b27c06719ca6f8cec93dcd2176e"
    sha256 x86_64_linux:   "3736780f2809b0449953cfb4ed85cc7d65b86e6c5c55aa98186062f8aff81d99"
  end

  # Ref: https://github.com/sphinxsearch/sphinx#sphinx
  deprecate! date: "2022-08-15", because: "is using unsupported v2 and source for v3 is not publicly available"

  depends_on "mysql@5.7"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "manticoresearch", because: "manticoresearch is a fork of sphinx"

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        revision: "9b58e92c965cd7e3208247ace3cc00d173397f3c"
  end

  patch do
    url "https://sources.debian.org/data/main/s/sphinxsearch/2.2.11-8/debian/patches/06-CVE-2020-29050.patch"
    sha256 "a52e065880b7293d95b6278f1013825b7ac52a1f2c28e8a69ed739882a4a5c3a"
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

    # Security fix: default to localhost
    # https://sources.debian.org/data/main/s/sphinxsearch/2.2.11-8/debian/patches/config-default-to-localhost.patch
    inreplace %w[sphinx-min.conf.in sphinx.conf.in] do |s|
      s.gsub! "9312", "127.0.0.1:9312"
      s.gsub! "9306:mysql41", "127.0.0.1:9306:mysql41"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"searchd", "--help"
  end
end
