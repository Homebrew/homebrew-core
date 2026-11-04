class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.20.0.tar.gz"
  sha256 "38705f51b61ac0636a5fd064f9a77fafabc7227b2aa2513f1b14c8bb1102affc"
  license all_of: ["BSD-3-Clause", "blessing"]
  compatibility_version 1
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3dfcba2386d9c18d2e143dd4b0dac1d797fe5db5741a8bb5035651eeb5e9dea4"
    sha256 cellar: :any, arm64_tahoe:       "2c02731856d55c9ca87704239fcfaa6a4d894d26ca045a4109af58907db8faec"
    sha256 cellar: :any, arm64_sequoia:     "4e3dcb761e6f51081248b5c6d062014294208862f7186ba0465d699956705e9f"
    sha256 cellar: :any, arm64_linux:       "94a037ed932d04c692f1a67aab6c6990f0fa1d0be6c1957a4293e8112dbe9cee"
    sha256 cellar: :any, x86_64_linux:      "acfacedec0da5b23ab88de0dec65dcafb9f8f1e5047fc49c7b0dc30742deaa53"
  end

  depends_on "openssl@4"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test # check for conflicts on Linux

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
    # Work around "install: mkdir .../lib: File exists"
    ENV.deparallelize { system "make", "install" }

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
    school = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', json_extract('{"age": 13}', '$.age'));
      select name from students order by age asc;
    SQL

    names = pipe_output(bin/"sqlcipher", school, 0).strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
