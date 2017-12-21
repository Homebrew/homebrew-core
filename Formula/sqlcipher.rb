class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.2.tar.gz"
  sha256 "69897a5167f34e8a84c7069f1b283aba88cdfa8ec183165c4a5da2c816cfaadb"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "0179493d2ae3349781310155fe73cf5c9a971e85a5b8e4551a6b366ad3003048" => :high_sierra
    sha256 "c4dfe2030b5524da4908575dbe7da65fa5401bbd8eebfec17b59429974782e69" => :sierra
    sha256 "8d56730a47c29d85dcb982ab24211dbf368b3832bd496263d5c2dc82d9f2ef7a" => :el_capitan
    sha256 "e59688acf58ae684192badd200a355ad70621641d3342c96a9af3518c15c1317" => :yosemite
  end

  option "with-fts", "Build with full-text search enabled"

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    if build.with?("fts")
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS5"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_JSON1"
    end

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
