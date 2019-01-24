class Sphinx < Formula
  desc "Full-text search engine"
  homepage "https://sphinxsearch.com/"
  url "https://sphinxsearch.com/files/sphinx-2.2.11-release.tar.gz"
  sha256 "6662039f093314f896950519fa781bc87610f926f64b3d349229002f06ac41a9"
  revision 1
  head "https://github.com/sphinxsearch/sphinx.git"

  bottle do
    sha256 "d1b6c4ccb5a7abda11efcb751385ebd7475257d5450057e2b95eaf980b3577d5" => :mojave
    sha256 "2000da0557815ad4b78c3fd743d26400dde1c20a4fc4a152c583d95e989b2435" => :high_sierra
    sha256 "c7f8c90458e53dbf84afd90b7640b9a37acec72dae091f8afeee737ed01abc50" => :sierra
  end

  depends_on "mysql"
  depends_on "openssl"

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
