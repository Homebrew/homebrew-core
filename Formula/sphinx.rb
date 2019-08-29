class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  revision 3
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    sha256 "08b4c63d3eb7984b42ae716db0968ff9290752866b008986817f252bdd0c8843" => :mojave
    sha256 "cc087ddbceb97fea4fd3bf32e53394675519e89102ec968e4d68eae10af06930" => :high_sierra
    sha256 "7922ac605b2bde97aa86a87a524c2a4cac2504047e2c78bcd05b055220862e32" => :sierra
  end

  depends_on "mysql"
  depends_on "openssl@1.1"

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
