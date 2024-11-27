class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3470000.tar.gz"
  version "3.47.0"
  sha256 "83eb21a6f6a649f506df8bd3aab85a08f7556ceed5dbd8dea743ea003fc3a957"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f4716de629ecdf2acf41951e753e7d5f10d154915fad2ce4484231e36f13ade0"
    sha256 cellar: :any,                 arm64_sonoma:  "3c1e59085e104ef0c1ea1e867300797329c403f46cd4cf15cb7c1a0b19bb1b4a"
    sha256 cellar: :any,                 arm64_ventura: "4a4312a5da0dea4e6be511f3581ce11f166c20d34f327b62686ff1c6f5c22b59"
    sha256 cellar: :any,                 sequoia:       "a36aaf898c49bdc6ab939f323dad41502c9773d5f4d92f028023d62b64d68acf"
    sha256 cellar: :any,                 sonoma:        "dfc775408f49afdaf1238e2428c292336bcd20d5ff152dcb83d55b1646649748"
    sha256 cellar: :any,                 ventura:       "5756aaabf9cf51b3ba263fd38aeeac189fae38d2d281a0fd48e7f47fb95bd5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "876ee5b13d16e4147a7ed7df891037188dba92d016d3aeb922eb785bd2f5a816"
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
