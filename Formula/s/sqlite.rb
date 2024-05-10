class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2024/sqlite-autoconf-3450300.tar.gz"
  version "3.45.3"
  sha256 "b2809ca53124c19c60f42bf627736eae011afdcc205bb48270a5ee9a38191531"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "253a7732af34b28f992072e84d9977d511844a0ebd238e94a5cb2f3fe254604c"
    sha256 cellar: :any,                 arm64_ventura:  "844fbdee84f718f211936a2aea851a6983af3501533af643afccb17314e30fd2"
    sha256 cellar: :any,                 arm64_monterey: "e51cd4fb90a3a233f8b19d0068f1f4dfd537198be60b25261069b86a463090d5"
    sha256 cellar: :any,                 sonoma:         "47e8a06001c02bd20d69431a76023baa4662a60127faf9fb8a3106d5f532dd29"
    sha256 cellar: :any,                 ventura:        "0b7a573709f3fad083805cd2cf0d7649721386a177cc18a08613c10a2d4c9753"
    sha256 cellar: :any,                 monterey:       "71900ed318d6491eac58d5828b46e939f8dbcb5e1b1cb70c6bbc8c21bbe93192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3542fea62b40b86e30d357fab3679ede4e2172662b594bf638464ae9708154"
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
