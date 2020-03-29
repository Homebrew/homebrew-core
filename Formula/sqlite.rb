class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2020/sqlite-autoconf-3310100.tar.gz"
  version "3.31.1"
  sha256 "62284efebc05a76f909c580ffa5c008a7d22a1287285d68b7825a2b6b51949ae"

  bottle do
    cellar :any
    sha256 "e09e8c96db88178e4f47b0cdab6477c46fa582326900ec9309c3ce1b9f7ff9aa" => :catalina
    sha256 "db7e3a6498bfdb4b4ceb8e8416020e2ad70de14975437f2e2a027485daeb2202" => :mojave
    sha256 "c49ef2494ec483a37895a7ba454c90b6e280e8b0a0db52399c9842617c150cab" => :high_sierra
  end

  keg_only :provided_by_macos, "macOS provides an older sqlite3"

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
      --enable-session
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
