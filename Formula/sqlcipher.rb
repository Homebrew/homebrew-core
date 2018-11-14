class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.2.tar.gz"
  sha256 "69897a5167f34e8a84c7069f1b283aba88cdfa8ec183165c4a5da2c816cfaadb"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d55d1ac70d2d2e5ca66ae68bfd30ee5586ceb33a8fbceb24ab22a6818f4adf12" => :mojave
    sha256 "0d2f0b708f10c458c938898e64a73dfa5ef2000505bfb0c25b257237f2612121" => :high_sierra
    sha256 "d13b038f0b387475ac5bd34d42ed7306d72bdc2f73f4bf5b2d80da862d0d9413" => :sierra
  end

  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
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
