class Virtualpg < Formula
  desc "Loadable dynamic extension for SQLite and SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/virtualpg/index"
  url "https://www.gaia-gis.it/gaia-sins/virtualpg-1.0.1.tar.gz"
  sha256 "9e6c4c6c1556b2ea2a1e4deda28909626c3a8b047c81d6b82c042abdb9a99ec8"

  bottle do
    cellar :any
    sha256 "a5e8e5a7114fe2e01f5599bf9cb57c86ffb76018cc17209804b857dc640bf404" => :sierra
    sha256 "e4ef5b53bbe9ee135d5fc2bb4c3a3d48f5f3eabfdb595c4847c65ff280a70032" => :el_capitan
    sha256 "ff726d86b7c7124bc2af33a47918e7c7bd07932c20d524e7cb60cb611a617ab7" => :yosemite
    sha256 "7388a7be8131848917364ecc747eff89b8818eb90d6eb13d364753042097d8bf" => :mavericks
  end

  depends_on "libspatialite"
  depends_on "postgis"

  def install
    # New SQLite3 extension won't load via SELECT load_extension('mod_virtualpg');
    # unless named mod_virtualpg.dylib (should actually be mod_virtualpg.bundle)
    # See: https://groups.google.com/forum/#!topic/spatialite-users/EqJAB8FYRdI
    # needs upstream fixes in both SQLite and libtool
    inreplace "configure",
    "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
    "shrext_cmds='.dylib'"

    system "./configure", "--enable-shared=yes",
                          "--disable-dependency-tracking",
                          "--with-pgconfig=#{Formula["postgresql"].opt_bin}/pg_config",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Verify mod_virtualpg extension can be loaded using Homebrew's SQLite
    system "echo \"SELECT load_extension('#{opt_lib}/mod_virtualpg');\" | #{Formula["sqlite"].opt_bin}/sqlite3"
  end
end
