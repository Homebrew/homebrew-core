class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2026/sqlite-autoconf-3510200.tar.gz"
  version "3.51.2"
  sha256 "fbd89f866b1403bb66a143065440089dd76100f2238314d92274a082d4f2b7bb"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7ebe1089758247f108cae46ba047aa9d45dbd562b7bbfeb1678b4e5b547bddc"
    sha256 cellar: :any,                 arm64_sequoia: "cb1870c29597328d998dbb1a073e0b74a7b3d78af86c7355bbde2ba1accbd837"
    sha256 cellar: :any,                 arm64_sonoma:  "8e53d196a3c0f85e0d1c119872c45f40440357ebf1f074865e2117d57353e341"
    sha256 cellar: :any,                 tahoe:         "8314c1fc8c1c89daf2f9a9281d782ee644cea7059a0adbe2718584d914b59fc4"
    sha256 cellar: :any,                 sequoia:       "b5bc8cee3e3a3a7fe801e6fa363418ace4eb7cd3effcc03d4eb288fde68a446d"
    sha256 cellar: :any,                 sonoma:        "2ee523c62053996fa1a620ae756376642e76b952abae1601b55def1ddd6e66a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4928c40f0de780b84faad3def71dd9288634b20101fb3a17dc5c78f9bbdd2a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f75b216a1653cde3decc1af5c7db7578c98d63595cb9ef14a6eacf8d96e1521"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

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
      "--with-readline-cflags=-I#{Formula["readline"].opt_include}",
      "--with-readline-ldflags=-L#{Formula["readline"].opt_lib} -lreadline",
    ]
    args << "--soname=legacy" if OS.linux?

    system "./configure", *args, *std_configure_args
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
