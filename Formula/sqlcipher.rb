class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.2.0.tar.gz"
  sha256 "105c1b813f848da038c03647a8bfc9d42fb46865e6aaf4edfd46ff3b18cdccfc"
  revision 1
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "dbe202e4ca6f3c16bcac80c8466b9202b0322993044ef1fc8a008d8f150bb689" => :mojave
    sha256 "539d88f8b348dc79d1f63fc7719e1a35bc6a451c0fd06c0df2616d1a58372cc6" => :high_sierra
    sha256 "6b84524fa20fc0d6e9ff0c15242760cfb5516bd50042fa4d79ea49ce93c62d55" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl@1.1"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    # Build with full-text search enabled
    args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS5"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', json_extract('{"age": 13}', '$.age'));
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlcipher < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
