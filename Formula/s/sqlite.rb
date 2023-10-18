class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3430200.tar.gz"
  version "3.43.2"
  sha256 "6d422b6f62c4de2ca80d61860e3a3fb693554d2f75bb1aaca743ccc4d6f609f0"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6911319bc3cd3be7b63d3f5a07b859011fd977b48f1d455c40da1cbd85d1e1aa"
    sha256 cellar: :any,                 arm64_ventura:  "15519c90d32f12a2a4462b4c7822d7b3885e211ddb98957b2256b49dbf54e48f"
    sha256 cellar: :any,                 arm64_monterey: "4dca3e726fa072faad306f87e9f0440545107b0a73b80e714800b8eb0b5118df"
    sha256 cellar: :any,                 sonoma:         "96e50e9d331b273ff3b490b91e1ce7c31e2ef0ed952f44c3653eefe4e9cdd342"
    sha256 cellar: :any,                 ventura:        "187252f4128c2d2e9460f9c3a1e549b14a4f83265166f91c074ebe11f351cb83"
    sha256 cellar: :any,                 monterey:       "e1271c53bfc11db0a422e52f2bc258539590628687089503e7988dbf6ad7e1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a33f0bfe15dde5c666749f064999dcffba30de3190f42d90232d5b2b2528cb"
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

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/sqlite3.pc", prefix, opt_prefix
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
