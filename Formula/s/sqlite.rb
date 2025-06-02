class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2025/sqlite-autoconf-3500000.tar.gz"
  version "3.50.0"
  sha256 "3bc776a5f243897415f3b80fb74db3236501d45194c75c7f69012e4ec0128327"
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
    sha256 cellar: :any,                 arm64_sequoia: "f60f3563efb77f189f8031983202321acf157e8154894c0d2e2a95f4e9778bb1"
    sha256 cellar: :any,                 arm64_sonoma:  "1b6fe3f213111a6acd6ff1f0a306397bb24a91e07274e211c0e3c05e3402d249"
    sha256 cellar: :any,                 arm64_ventura: "ed9c712e252475b5c55475025a02c99f80f2249ff1f77831d05b6c5f8643573b"
    sha256 cellar: :any,                 sequoia:       "862abec653af982a1018b6fd993c8319cd08937e7804e1f9170b25d05ff77be6"
    sha256 cellar: :any,                 sonoma:        "d326d201776c20be1061c687ad12d1babf0e3be4b0fedf52badd89eb3bf57616"
    sha256 cellar: :any,                 ventura:       "ef974de3f1e6adf9cda43de2b77e100a33653699dde9a9f826985f103e9a848b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f32267be3e39fa4788b6ed85873541143f67f39fd2605a95c11a3857ae09ff0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0a8d015d81434c9130c51fef8cc67ae64214196549cb5906c20a6600a06fde8"
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
