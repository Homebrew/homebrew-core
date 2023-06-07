class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.5.4.tar.gz"
  sha256 "ea052fe634d729f9dd6b624016104de796faf87e487a9e868a07faee35957771"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "259c8f9cada08af155319d4463e2443314029f55f8fdabe0878f88b63a9e1cfd"
    sha256 cellar: :any,                 arm64_monterey: "379c1ee7dd9090e28a1dded4fba8af1c1b0bcae9ea340d7f2deedd7020590b7d"
    sha256 cellar: :any,                 arm64_big_sur:  "5c48c0efb5d404262feb9e933c518319feb799e003aef338ec04f4849b6f32c4"
    sha256 cellar: :any,                 ventura:        "b9e7fd7bc5714ba6e48998f5db62b1e0c1563d07bb5de719aee9326fbcafa406"
    sha256 cellar: :any,                 monterey:       "6291b0bc6a307fc54c3ec4d2c02fe78a4d7aa6e075c898a0b3e0f12d1c696ec9"
    sha256 cellar: :any,                 big_sur:        "df8d6bed2516e5386b2ab4f6ba6ccb166ffd7a3389020ea21e46468a610f2641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d66070f2dfa53334f44e1ff96f7bd46a3e2ff4f560d4f01fc7d8a2f51e8ec9b"
  end

  depends_on "openssl@3"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl@3"].opt_prefix}
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
