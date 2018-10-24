class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.4.2.tar.gz"
  sha256 "69897a5167f34e8a84c7069f1b283aba88cdfa8ec183165c4a5da2c816cfaadb"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "d3d7e77c5013fc8d31520f4d415c2c3bc4b045ef1b7016006826d9fcec078a4f" => :mojave
    sha256 "5b8aaeb3f3f41a57f171a3f1175887ea9d98511982354479d4171ebae24377c6" => :high_sierra
    sha256 "9462222059285b70d3a301812a38516ce0337e7dddb064ab052549124b9aca3f" => :sierra
    sha256 "6370ce68ccb2f598f42bee2f799f7e97d7f1bac75ec71aeb446ee57761436642" => :el_capitan
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
