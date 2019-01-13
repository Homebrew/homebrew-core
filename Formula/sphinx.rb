class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  revision 1
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    sha256 "60e5aa2a956bd9c4d1e35453b7b201e33a96565331d476423f26cd62873a3f10" => :mojave
    sha256 "b890cf523db9777c7d125842fd6b0a53fe9a7a5a4cb816389ba6f5ee6483c78d" => :high_sierra
    sha256 "55ce34bdedf13946fa614bde50839d93135eae720f1021e2c87807d04515ab18" => :sierra
    sha256 "c75e018d69afb7d3cb662ebd129af67607d47f7b7f71ce8ea95be75d66dc502d" => :el_capitan
    sha256 "f89b43df8735d295a55c74f18d6af4a1a10b9f3ae81df69713c27f9240f78d14" => :yosemite
    sha256 "4ec1f1ea71e17b9e924e9f36747d7184114463640f100022cdbb46202e46261f" => :mavericks
  end

  depends_on "mysql"
  depends_on "openssl"

  fails_with :clang do
    build 421
    cause "sphinxexpr.cpp:1802:11: error: use of undeclared identifier 'ExprEval'"
  end

  resource "stemmer" do
    url "https://github.com/snowballstem/snowball.git",
        :revision => "9b58e92c965cd7e3208247ace3cc00d173397f3c"
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
