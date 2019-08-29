class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  revision 3
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    sha256 "94b90c69f874065f016d997d0116a5904fe08ac8971de6f853226beae7728d5f" => :mojave
    sha256 "b2ebd3519b509a3afae2a915fe9744f4ef880a2a650820322c54ac27a07a0573" => :high_sierra
    sha256 "848eb3db1c267231d5bff8bd8e6cc5b24fcef37acd977dd9be93c0716c6fdde2" => :sierra
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
