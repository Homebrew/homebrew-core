class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "7ca5c11f70e460d6537844185621d5b3d683a001e6bad223d15bdf8eff322efa"
  license all_of: ["BSD-3-Clause", "blessing"]
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d61881ddfae96c3e69d405005e002671f277d8203fd50aacb46cf70d8973dbaf"
    sha256 cellar: :any,                 arm64_sequoia: "bcb402d7e851d17ad23eb0dd82fbaf932f2c7492ecb9534f4c0916be9957c6d7"
    sha256 cellar: :any,                 arm64_sonoma:  "7915d5b87a6bb15a239b9aac9f2bc2b2982acb9773df18e977073d1f19605744"
    sha256 cellar: :any,                 sonoma:        "e2bd63eb1680b3accc602fb98f597f669b2e2a71c024cefbf24d392d7527d0db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "206dc078df531bd440d544b5bf88490b41051d5506995d1a97305000a304e925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ee68d5c9601188f48062b783f313955426e4f996c870c2aa06fc2945fe55e7b"
  end

  depends_on "openssl@3"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test # check for conflicts on Linux
  uses_from_macos "zlib"

  def install
    # Build with full-text search enabled
    cflags = %w[
      -DSQLITE_HAS_CODEC
      -DSQLITE_ENABLE_JSON1
      -DSQLITE_ENABLE_FTS3
      -DSQLITE_ENABLE_FTS3_PARENTHESIS
      -DSQLITE_ENABLE_FTS5
      -DSQLITE_ENABLE_COLUMN_METADATA
      -DSQLITE_EXTRA_INIT=sqlcipher_extra_init
      -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown
    ].join(" ")

    args = %W[
      --disable-tcl
      --dll-basename=libsqlcipher
      --enable-load-extension
      --includedir=#{include}/sqlcipher
      --prefix=#{prefix}
      --with-tempstore=yes
      CFLAGS=#{cflags}
      LDFLAGS=-lcrypto
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    # Modify file names to avoid conflicting with sqlite. Similar to
    # * Debian  - https://salsa.debian.org/debian/sqlcipher/-/blob/master/debian/rules
    # * Liguros - https://gitlab.com/liguros/liguros-repo/-/blob/develop/dev-db/sqlcipher/sqlcipher-4.12.0.ebuild
    # * OpenBSD - https://codeberg.org/OpenBSD/ports/src/branch/master/databases/sqlcipher/Makefile
    [
      bin/"sqlite3",
      man1/"sqlite3.1",
      lib/"pkgconfig/sqlite3.pc",
      lib/"libsqlite3.a",
      lib/shared_library("libsqlcipher"),
      *lib.glob(shared_library("libsqlite3", "*")),
    ].each do |path|
      basename = path.basename.sub("sqlite3", "sqlcipher")
      if path.symlink?
        source = path.readlink.sub("sqlite3", "sqlcipher")
        rm(path)
        path.dirname.install_symlink source => basename
      else
        path.dirname.install path => basename
      end
    end
    inreplace lib/"pkgconfig/sqlcipher.pc", "-lsqlite3", "-lsqlcipher"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', json_extract('{"age": 13}', '$.age'));
      select name from students order by age asc;
    SQL

    names = shell_output("#{bin}/sqlcipher < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
