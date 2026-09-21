class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2026/sqlite-autoconf-3530400.tar.gz"
  version "3.53.4"
  sha256 "0e9483900e92cd5de8fd48d16bf9200145a61f7fd5be542a5ac81d8a9516eb9c"
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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "804bef8ca4631bf2cf790c2b0564cee7ace649eb4052f2e16da3ac9142e77f51"
    sha256 cellar: :any, arm64_tahoe:       "d09c4852f75e19c18c3e347ce73c81b0b864792046f079d074205522c735d3fc"
    sha256 cellar: :any, arm64_sequoia:     "4eefe9a700a6de4c31d20a16a2e675b51a24c87638d79fbc2195b952e7cb8d6a"
    sha256 cellar: :any, arm64_sonoma:      "45049bbdee244bc9d91e22c36629b5ba93b719b52c4d121b86392b3410be630f"
    sha256 cellar: :any, tahoe:             "58c8931be9f84faf36cd62062f161dcc7c70a104761a4d0753ef4398dd9f627f"
    sha256 cellar: :any, sequoia:           "f6752e93c0ddf55d10ae3aaea01d280be9632855649caa87daf1371fa6e26eb4"
    sha256 cellar: :any, sonoma:            "32f6a117203a602fe3e06f524c19e431965ecc0bf9ede4c11ab443551558cfe9"
    sha256 cellar: :any, arm64_linux:       "70f4fd9c239aa60c3b437d9c2638bd3186d920a19090cb62e2ce9f79f8e0a04c"
    sha256 cellar: :any, x86_64_linux:      "a7d570ed08f4678d8aee733ab6f12a3193891709b8047042b07b48b90473fad5"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
    school = <<~SQL
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    SQL

    names = pipe_output(bin/"sqlite3", school, 0).strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
