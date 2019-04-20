class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.11/xapian-core-1.4.11.tar.xz"
  mirror "https://fossies.org/linux/www/xapian-core-1.4.11.tar.xz"
  sha256 "9f16b2f3e2351a24034d7636f73566ab74c3f0729e9e0492934e956b25c5bc07"

  bottle do
    cellar :any
    sha256 "f802e17710ae6f4b01e2a85103537a5b39915984700207a42dd1ab1da43dfaf9" => :mojave
    sha256 "df8a268b9016f9b8cc60290bd28aa8281bb8739c0b13957425d48f22d24cb4da" => :high_sierra
    sha256 "a1a49718ad026797c150e012c712ad69a9d6e5a278a4750d0bddd1656a41014a" => :sierra
  end

  depends_on "python"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.11/xapian-bindings-1.4.11.tar.xz"
    mirror "https://fossies.org/linux/www/xapian-bindings-1.4.11.tar.xz"
    sha256 "9da356c8b20a66ea3d44002e24fee4ed961989d9ba726a13d13e8d56f216718d"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      ENV.prepend_create_path "PYTHON3_LIB", lib/"python3.7/site-packages"

      # Xapian bindings are not compatible with Sphinx-doc >= 2.0
      # According to https://trac.xapian.org/ticket/740 there is no way to build bindigs without documentation
      # As a workaround, we remove this step directly from the configuration script
      inreplace "./configure", "$PYTHON3 -c 'import sphinx;print(repr(sphinx.main))'", "[ true ]"

      inreplace "./python3/Makefile.in" do |s|
        s.gsub! "all-local: $(sphinxdocs)", "all-local:"
        s.gsub! "cp -R -p `test -r docs/html || echo '$(srcdir)/'`docs/html '$(DESTDIR)$(docdir)/python3'", "echo 'skip python doc'"
      end

      inreplace "./python3/Makefile.am", "cp -R -p `test -r docs/html || echo '$(srcdir)/'`docs/html '$(DESTDIR)$(docdir)/python3'", "echo 'skip python doc'"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-python3"

      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system "python3.7 -c 'import xapian'"
  end
end
