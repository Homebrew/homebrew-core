class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3430000.tar.gz"
  version "3.43.0"
  sha256 "49008dbf3afc04d4edc8ecfc34e4ead196973034293c997adad2f63f01762ae1"
  license "blessing"
  revision 1

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d87331cdb6eb402009bacafdb70d8de646fbf96265f611025aea6cf8f7f706d7"
    sha256 cellar: :any,                 arm64_monterey: "652d4ecf320ea647374fce510e195d1c20ebeed2c2a0f177c545de62c600baf2"
    sha256 cellar: :any,                 arm64_big_sur:  "f205b179eb5e2401fb360d0b0aabdbb46992190f100c7ef048d068b30f6e48d7"
    sha256 cellar: :any,                 ventura:        "273c47c1769f04c5f5ff3ac5cb9b4d6ac8b29284029127a11445089b2cb3ac65"
    sha256 cellar: :any,                 monterey:       "53b166583911c6482992143c622a9f70b42bf067b3eebcad754e1e347030c413"
    sha256 cellar: :any,                 big_sur:        "e4c03b50e1e1cc0794eba728625dfd9e79a7573b999408a328481150c23d46d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "596c57775ee52852050e1ae7a5e6b2259aa20c30d426e9bffab2e7153841fbb6"
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
