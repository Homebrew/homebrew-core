class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.4.2.tar.gz"
  sha256 "87458e0e16594b3ba6c7a1f046bc1ba783d002d35e0e7b61bb6b7bb862f362a7"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "cac60b27489ae08e4be4fffcb80c66208cc628889ce89295802983581a39febc" => :big_sur
    sha256 "9e9d5ee53f8a6f0d81981e91ef66052afd72d58eb50331ddf199dd74d8f339b6" => :arm64_big_sur
    sha256 "b6e926a4630f8b4547e5d71f5195bdde461ef08e54b9ae90a45644b11543cd9d" => :catalina
    sha256 "8d216a324ade956c2ec9b4dc94a676b27342e590c948b1c80ba49d602c885ccb" => :mojave
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
    args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_JSON1 -DSQLITE_ENABLE_FTS3 " \
                   "-DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS5 -DSQLITE_ENABLE_COLUMN_METADATA"

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
