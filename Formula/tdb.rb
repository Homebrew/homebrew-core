class Tdb < Formula
  desc "Trivial database library"
  homepage "https://tdb.samba.org"
  url "https://www.samba.org/ftp/tdb/tdb-1.4.2.tar.gz"
  sha256 "9040b2cce4028e392f063f91bbe76b8b28fecc2b7c0c6071c67b5eb3168e004a"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "python" => :build

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--prefix=#{prefix}", "--disable-rpath"
    system "make", "test"
    system "make", "install"
  end
end
