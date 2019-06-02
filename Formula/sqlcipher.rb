class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.2.0.tar.gz"
  sha256 "105c1b813f848da038c03647a8bfc9d42fb46865e6aaf4edfd46ff3b18cdccfc"
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "2c65f56b33f45497f7875770a7e9c2cb44d73b0019f8cb210746b3f0347c6eb4" => :mojave
    sha256 "03413b92c147ba14b7201a8724d2649796d2885d0149a568a23ca068c80f9b0a" => :high_sierra
    sha256 "e4b5446284de6dc8d3bdb1896ce49d56535f94fc4d06ee1a008fb9a457897f1a" => :sierra
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
