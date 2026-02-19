class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "7ca5c11f70e460d6537844185621d5b3d683a001e6bad223d15bdf8eff322efa"
  license all_of: ["BSD-3-Clause", "blessing"]
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e68a18abaa2253082f86d38b43c01ed3df41ecc999ef7de6b1bebe041e8f876d"
    sha256 cellar: :any,                 arm64_sequoia: "f22dc347644451f51cfe87910411a10d0c6fbc2eda49f86e80485512d5d70ffc"
    sha256 cellar: :any,                 arm64_sonoma:  "71f235e6480cc75f46a898afc90bca59cf7cdf5a0a28493fc658156a72b6a0c6"
    sha256 cellar: :any,                 sonoma:        "c718a9d068cf45ad7a0a265862b8953dd3e87a7660f5544a04ec4e6542aded9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545b6d269df5b4ca96527f4dda09f8753015f7ea8646a311c3b5551f58133e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a7327016c96673dfbe06b4de00814345cf914f1e377aadd5340d8583329f32"
  end

  depends_on "openssl@3"

  # Build scripts require tclsh. `--disable-tcl` only skips building extension
  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test # check for conflicts on Linux

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
