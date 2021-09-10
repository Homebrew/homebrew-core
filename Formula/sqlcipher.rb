class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.4.3.tar.gz"
  sha256 "b8df69b998c042ce7f8a99f07cf11f45dfebe51110ef92de95f1728358853133"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2395b5999cde9cd6c8f53dd595a2827d8e2bdef8b801879b753378728a3cc94f"
    sha256 cellar: :any,                 big_sur:       "97328f386addff936379b66ae032b3341cc6f047b7453e1a837cdc8a00b06653"
    sha256 cellar: :any,                 catalina:      "826fa6703434de743eec33ca60db392fe772ace12e4eb3720c106d675c3edc70"
    sha256 cellar: :any,                 mojave:        "123c63643cec4a0503993ba6f9a124a5f781db317c311103da82d91a895808e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "994d4f361a64199f7330b1a3018f098ac9237a12580038eddd277f76d4665ac9"
  end

  depends_on "openssl@1.1"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl@1.1"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    # Build with full-text search enabled
    cflags = %w[
      -DSQLITE_HAS_CODEC
      -DSQLITE_ENABLE_JSON1
      -DSQLITE_ENABLE_FTS3
      -DSQLITE_ENABLE_FTS3_PARENTHESIS
      -DSQLITE_ENABLE_FTS5
      -DSQLITE_ENABLE_COLUMN_METADATA
    ].join(" ")
    args << "CFLAGS=#{cflags}"

    args << "LIBS=-lm" if OS.linux?

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
