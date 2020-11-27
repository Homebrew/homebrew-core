class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.4.2.tar.gz"
  sha256 "87458e0e16594b3ba6c7a1f046bc1ba783d002d35e0e7b61bb6b7bb862f362a7"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "44c12e97db60edbfa80ec5e78eb5189922f15ad162010f2510fa04b7d9d5026e" => :big_sur
    sha256 "946c98f80ccd6142d0bc50c1c309c8a064ae9973ca0c519055aec02bb2804462" => :catalina
    sha256 "b3470dd97bda6b129759ffc22f129b5bd02a78883ac98ee11f1108e327b41064" => :mojave
    sha256 "0f5ae0170acc197d506544f541c67e3ad7b9698a3104fd39a5c2a143c60562fc" => :high_sierra
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
