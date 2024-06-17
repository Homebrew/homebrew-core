class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3460000.tar.gz"
  version "3.46.0"
  sha256 "6f8e6a7b335273748816f9b3b62bbdc372a889de8782d7f048c653a447417a7d"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "57bdf2c2372c876ad1b712eeff3c158fa17dcdcc2a82f0b6d28888191c7acb48"
    sha256 cellar: :any,                 arm64_ventura:  "f7b3b2b320099ac6149c4f9248403acb8d6c3c9b6c8707233bb8fecb899f532c"
    sha256 cellar: :any,                 arm64_monterey: "02ccb7e5f55be4d2bbc98869053252ffefbbc27f031914e25e2cfe3280f0f0b5"
    sha256 cellar: :any,                 sonoma:         "f5991da95d03429faaa777f0475959b8b2ae11a46e47b4d013e8e428443c1ea9"
    sha256 cellar: :any,                 ventura:        "362a17090747680787abc65bfa6b8e2af3b6245e39edd5c3ca5f77b2dc05d203"
    sha256 cellar: :any,                 monterey:       "9117120ebe7933b7a3c588d62bc804d90f575175c7fe082eadee257fa51727e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a0e215241a611985229353273a803339372c7a075f040fe304388c0a044084"
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
