class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.15.0.tar.gz"
  sha256 "21f5dfb2558a2a87740bb060ba75aadfec2e6119e08a87c3546c54751395a28d"
  license all_of: ["BSD-3-Clause", "blessing"]
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91a94f9cadd4d8606fdb52535e59af11bd96a4b3e0108d9101622fae854dac51"
    sha256 cellar: :any,                 arm64_sequoia: "3e7a59bca8cce9934af8dd0fe8a7a69cca36b18d36859449738ce64136073509"
    sha256 cellar: :any,                 arm64_sonoma:  "c9f84ddb061adf54d9309c882f43e605630b88922919cf1988b2bfcd660e61e7"
    sha256 cellar: :any,                 sonoma:        "e867296dd064a0ea1c335ba8095c5bb652133e4d957dfbf7c81214930372f123"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a0686c0beb8d1e13ac247f814f9b18146d533989c1cc245515feda4c105d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcc555f60ff4face131443236f0419cdd21faad2afdf3765ee1246d40bab68d"
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
