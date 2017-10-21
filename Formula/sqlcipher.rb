class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.1.tar.gz"
  sha256 "4172cc6e5a79d36e178d36bd5cc467a938e08368952659bcd95eccbaf0fa4ad4"
  revision 2

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

  # Upstream SQLite patch for CVE-2017-10989
  patch :p0 do
    url "https://sqlite.org/src/vpatch?from=0db20efe201736b3&to=66de6f4a9504ec26"
    sha256 "41d0570cbf80429e556e612acd5eeddcff0e586264a6bcb80bd5a27abc9159a2"
  end

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
