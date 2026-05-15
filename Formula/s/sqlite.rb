class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2026/sqlite-autoconf-3530100.tar.gz"
  version "3.53.1"
  sha256 "83e6b2020a034e9a7ad4a72feea59e1ad52f162e09cbd26735a3ffb98359fc4f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "603cd1f8bb653f313abfbebda1231ebcc9b9709527187d9d178dd89c63c063b5"
    sha256 cellar: :any,                 arm64_sequoia: "0b460f9cac31f80121550e33c0b9c88ca29e92ab08465aacbd4d82990a7713ff"
    sha256 cellar: :any,                 arm64_sonoma:  "ee0636a210447f3503a9343749fbf0e8fa70f44dddd0077d6c8c40b02c24e795"
    sha256 cellar: :any,                 tahoe:         "1a17fc2beea485700567911cd274fdc9f07e5263b33b572443283f750bca46ff"
    sha256 cellar: :any,                 sequoia:       "000449b6566f6f1d59706b5ce402aa3cf6838e0095ee38c402229de0c50c2ddc"
    sha256 cellar: :any,                 sonoma:        "3d617a4a8a8b5dbafa71ea6b757bc0d5b39cf343cd8e0caad9acece728839fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c6e567616b54d3e6a31777abe5797275b25b4704e6eedf30a81c0882322628d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6cce8a2676eb574417ab9144488eb94cc6174a8d7564ddb53d443e457591a9a"
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
      "--with-readline-cflags=-I#{Formula["readline"].opt_include}",
      "--with-readline-ldflags=-L#{Formula["readline"].opt_lib} -lreadline",
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
