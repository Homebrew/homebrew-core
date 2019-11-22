class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.2.0.tar.gz"
  sha256 "105c1b813f848da038c03647a8bfc9d42fb46865e6aaf4edfd46ff3b18cdccfc"
  revision 1
  head "https://github.com/sqlcipher/sqlcipher.git"

  bottle do
    cellar :any
    sha256 "d75fad68d4754a6e4df6b42dd67e30060841ed4c4b76f11c876ae56fe8c5b634" => :catalina
    sha256 "6d341263b65d34595b30df94ff816f9554f7101860709433644cc180ab551298" => :mojave
    sha256 "723521130f5dbebf48d7eb61eb3525f7d779261cc4c3760724e65f4a87315cd8" => :high_sierra
    sha256 "0168ffe787b5aa7742861922a503118aa5140eac7572d3270a42e7dfb68f04c6" => :sierra
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
