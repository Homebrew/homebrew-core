class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2026/sqlite-autoconf-3530200.tar.gz"
  version "3.53.2"
  sha256 "588ad51949419a56ebe81fe56193d510c559eb94c9a57748387860b5d3069316"
  license "blessing"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "16898abae03d67288ea3aa7cbfdb3d10edd02cd516f4206e1b8384813b5d2c57"
    sha256 cellar: :any, arm64_sequoia: "e7a5c00c3acb3ef2179f3b67b1de47f551e0f76e68192c0402f58e08d05b8096"
    sha256 cellar: :any, arm64_sonoma:  "a291291be08ecc18ff48989c67c6d351c0c62ce37520685ccf800ef46bf9c421"
    sha256 cellar: :any, tahoe:         "f54170bc720b04be188c80c6281fadcbac9b7778263da34e9d234c9db79a7af7"
    sha256 cellar: :any, sequoia:       "52c1cb2a5fda67b26983eb63281712d22c8eb271db20726f9f1fe0b27d4fd2fe"
    sha256 cellar: :any, sonoma:        "742847c8da58c350a7b5f1806fdf932d2fee2bcc355f223f64153ff1ed5ef4b4"
    sha256 cellar: :any, arm64_linux:   "675f373cc2c2f221f91cf9137a4d2d8d8daac58708caedd30e1ce6bafd840407"
    sha256 cellar: :any, x86_64_linux:  "0610f87c0fbf90d83bd05c3ac04a4ce4d93d77af2b39b277577b1267ac6bb1b7"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", %w[
      -DSQLITE_ENABLE_API_ARMOR=1
      -DSQLITE_ENABLE_COLUMN_METADATA=1
      -DSQLITE_ENABLE_DBSTAT_VTAB=1
      -DSQLITE_ENABLE_FTS3=1
      -DSQLITE_ENABLE_FTS3_PARENTHESIS=1
      -DSQLITE_ENABLE_FTS5=1
      -DSQLITE_ENABLE_GEOPOLY=1
      -DSQLITE_ENABLE_JSON1=1
      -DSQLITE_ENABLE_MEMORY_MANAGEMENT=1
      -DSQLITE_ENABLE_RTREE=1
      -DSQLITE_ENABLE_STAT4=1
      -DSQLITE_ENABLE_UNLOCK_NOTIFY=1
      -DSQLITE_MAX_VARIABLE_NUMBER=250000
      -DSQLITE_USE_URI=1
    ].join(" ")

    args = [
      "--enable-readline",
      "--disable-editline",
      "--enable-session",
      "--with-readline-cflags=-I#{formula_opt_include("readline")}",
      "--with-readline-ldflags=-L#{formula_opt_lib("readline")} -lreadline",
    ]
    args << "--soname=legacy" if OS.linux?

    system "./configure", *args, *std_configure_args
    ENV.deparallelize
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
  end

  test do
    path = testpath/"school.sql"
    path.write <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
