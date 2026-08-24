class Sqlcipher < Formula
  desc "SQLite extension providing 256-bit AES encryption"
  homepage "https://www.zetetic.net/sqlcipher/"
  url "https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v4.18.0.tar.gz"
  sha256 "1df02d1b346fa27feaf2da2cb2c0d8209e788248e461ec288718aa5d3e9643e5"
  license all_of: ["BSD-3-Clause", "blessing"]
  head "https://github.com/sqlcipher/sqlcipher.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d2d1915e6c863d4275ab6e652ff92525d680d809fa4bc23ddc8cace90e1e8966"
    sha256 cellar: :any, arm64_sequoia: "6dd403474a83b92f681e8846302b39a37565c2c3aef7ea8c8d482c1a568d7c2c"
    sha256 cellar: :any, arm64_sonoma:  "8c60b8bc8026f544414618a277d729a2520de2252b72c5cffd3479aadf312334"
    sha256 cellar: :any, sonoma:        "1acbafbf90531e442484924e9f1b617e36e5efb01424d219814299ba0962c6f6"
    sha256 cellar: :any, arm64_linux:   "e419e1ffe04932fea5ece81820804df28c8d54fd179c00c4b321b8d482587ea5"
    sha256 cellar: :any, x86_64_linux:  "119735044cb333401779954331c75c791636d10b4e8c7fcce19f436075f7b5be"
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
