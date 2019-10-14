class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  revision 3
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    rebuild 1
    sha256 "8409d9e7184255c8bb37ef03f4b45821695caedf9084aaf00407beb16ef1e2af" => :catalina
    sha256 "13e53eacdbc5d261aa15541fa41ec217396dba2f585a4248113cb97587462b80" => :mojave
    sha256 "893a65095760623c3371c77c348e973267275162c6318dcab8812ea8aaa72ed4" => :high_sierra
  end

  depends_on "mysql@5.7"
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
