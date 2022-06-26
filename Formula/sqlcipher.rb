class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/v4.5.1.tar.gz"
  sha256 "023499516ef2ade14fbcdbe93fb81cc69458ae6cb3544614df8dbef34835b406"
  license "BSD-3-Clause"
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "03acf35ce03a8f3d4e1167ff24c5dec9ad9b916e1436a5f6f277282258711ae7"
    sha256 cellar: :any,                 arm64_big_sur:  "8a87822ef33cbc8565f2bbad2d153d54edfdd7a5ff8a47fd996eca6fad6d62af"
    sha256 cellar: :any,                 monterey:       "fc0ee217cff3910c8b81542a288a726703042147117479acc2aeb8cdebfdafbb"
    sha256 cellar: :any,                 big_sur:        "caad14a088524b881457585ec3c42f270e4d1cd8236889904722bfe9c6cca58c"
    sha256 cellar: :any,                 catalina:       "2b550d10a93fcc1e2161e7c67099ca3139b9bc5d4b7b8290218424456cdd570f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1bb333e4e83153c146c888d64e645e5b884f07d427fcb5e67c27190676b7da"
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
