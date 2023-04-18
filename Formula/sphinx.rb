class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/sphinxsearch/sphinx.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "29d4a1cb48d6bb64fe32f3fbb448687a7f48c5a309fbd464a05ab4df30e0f4e0"
    sha256 arm64_monterey: "0a7686315aa341f8d12d0a46f7d7f13bf921e85b59a285292bd67be0ec6cb9c5"
    sha256 arm64_big_sur:  "0702c419e4680937a9e9c1970074e7e785b5b7307c90bb852f849bebeda8bd17"
    sha256 ventura:        "1895d3008883802c3592915f000e9e9544201cc96afcfda1edb9635eb8e4bcf4"
    sha256 monterey:       "56a74fda35d958988e0fa6c5420074a5933b47f990aee4c42c05bf57cce2d8a5"
    sha256 big_sur:        "2969e6045b58a3bb2b68c45cf687606a02c15d397760d50a4d7a345779f2f69c"
    sha256 catalina:       "ce510deb9be121b4fbae238dcd626cfde7666cc73979412f54b8726ca689e659"
    sha256 x86_64_linux:   "ee340d578c2a8e8e91e2624cbd505d06cc054e6f37dff83124a8ac115275f4f2"
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
