class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3440200.tar.gz"
  version "3.44.2"
  sha256 "1c6719a148bc41cf0f2bbbe3926d7ce3f5ca09d878f1246fcc20767b175bb407"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e4b89c838f4523296c2250d68a1b5f74196ea2ed15bd5021afeb143ede57ebb"
    sha256 cellar: :any,                 arm64_ventura:  "51a64970ce486193db224b93411b5a778c5aac6a94867ddf78022729ca398b99"
    sha256 cellar: :any,                 arm64_monterey: "74d8c1f594efd763616c987e2deab34f251773b557ca83f57577e4dff2ec4dee"
    sha256 cellar: :any,                 sonoma:         "7fa600ef1bfcb843a3f878ed1a6dbc75757a1cfcbdd792ca5f3e39bdc593e719"
    sha256 cellar: :any,                 ventura:        "39b5d014056a8d13c8fe7cb40b3ba9d1112bc0fbfef128c1d31de5c9e27ad007"
    sha256 cellar: :any,                 monterey:       "0e59c0d54402756d5ec0c5966e73b021bcfa94f3b45e9090eb608d6577756018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf310d7beddd0bf9fc2fb4ad359b03298fa48370f0014485dde77c81d80c750"
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
