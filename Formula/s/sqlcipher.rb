class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.14.0.tar.gz"
  sha256 "67fb27e967a4a6968c0905691c89c908e7250dddc581b887c19ef981c737e473"
  license all_of: ["BSD-3-Clause", "blessing"]
  revision 1
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a9ce5392427319186fcefd6d35be75cf869b8575d99736e74bfec9793617f23"
    sha256 cellar: :any,                 arm64_sequoia: "29f75862a32e0ded62b2dd5482c2ff775d17dfa919ad2237d5b8764f99ecafb4"
    sha256 cellar: :any,                 arm64_sonoma:  "7bc4be6370d3a6945cd31b1a16aa906d38af4433f727afbba4c9b36aed07bd41"
    sha256 cellar: :any,                 sonoma:        "99344c9dcc011eaffc73fb86c0b041d3ca6373c37f93d5708a8f8b76a75d3903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b319879b12eb71ae4b5f2c330ffa2df3fe3c754a84edaa940ed0acdfae617ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52527b153b49ec7bd9e6f63cb8cab3ae0b218699df0751ab160d171c383124ff"
  end

  depends_on "openssl@4"

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
