class Sqliteodbc < Formula
  desc "SQLite ODBC driver"
  homepage "http://www.ch-werner.de/sqliteodbc/"
  url "http://www.ch-werner.homepage.t-online.de/sqliteodbc/sqliteodbc-0.9996.tar.gz"
  sha256 "8afbc9e0826d4ff07257d7881108206ce31b5f719762cbdb4f68201b60b0cb4e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a49afbd00eb6230ecf0a0a4573c961fe697ab6326998f2a894348d8509dc1c0d" => :mojave
    sha256 "6afd81a210f7a0f7b70e70d4d5b89a659c4cf2c9916d85ff65d89ef042bdba52" => :high_sierra
    sha256 "73755a497df2713b8f3cc9cd0f19df24aaab01f33bf001be3718c5f8318c784c" => :sierra
  end

  depends_on "sqlite"
  depends_on "unixodbc"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    lib.mkdir
    system "./configure", "--prefix=#{prefix}", "--with-odbc=#{Formula["unixodbc"].opt_prefix}", "--with-sqlite3=#{Formula["sqlite"].opt_prefix}"
    system "make"
    system "make", "install"
    lib.install_symlink "#{lib}/libsqlite3odbc.dylib" => "libsqlite3odbc.so"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].opt_bin}/dltest #{lib}/libsqlite3odbc.so")
    assert_equal "SUCCESS: Loaded #{lib}/libsqlite3odbc.so\n", output
  end
end
