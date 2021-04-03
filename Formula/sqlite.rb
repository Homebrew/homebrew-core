class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2021/sqlite-autoconf-3350400.tar.gz"
  version "3.35.4"
  sha256 "7771525dff0185bfe9638ccce23faa0e1451757ddbda5a6c853bb80b923a512d"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dc73e344c364d891047ab1b4fa54c25196b5fb61ac646d3ac3c731311d81e9a4"
    sha256 cellar: :any, big_sur:       "6f491b7ef85515ede5f193db760117c39f4d4f2dadb482c2f48410b2ea00d1eb"
    sha256 cellar: :any, catalina:      "615597e87a1804124b019e35609539878eaf17e52f58ef03ce2ed1cd9536b299"
    sha256 cellar: :any, mojave:        "996aa3f07c2a41ef497bed0c00fbff1272d89e3a282ac8661e7ad5533f09d533"
  end

  keg_only :provided_by_macos

  depends_on "readline"

  uses_from_macos "zlib"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1"

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
