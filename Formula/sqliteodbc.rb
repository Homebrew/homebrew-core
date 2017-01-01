class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "http://www.ch-werner.de/sqliteodbc/"
  url "http://www.ch-werner.de/sqliteodbc/sqliteodbc-0.9995.tar.gz"
  sha256 "73deed973ff525195a225699e9a8a24eb42f8242f49871ef196168a5600a1acb"

  bottle do
    cellar :any
    sha256 "3b50601a3dd200c8706dc421b7d4ec26bdcd316d5165100ca6d87533fb35ecf1" => :sierra
    sha256 "2ab8fb2d6cd9bf40121b4c92c88d34001be074a3d7a41e4d14bf897b35868e77" => :el_capitan
    sha256 "3a05177887821c6ed86053bcc54795ca7968eb541a9fc689c6b0952c88ed88b8" => :yosemite
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  def install
    lib.mkdir
    system "./configure", "--prefix=#{prefix}", "--with-odbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
    lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
