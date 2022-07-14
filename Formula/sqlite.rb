class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3390100.tar.gz"
  version "3.39.1"
  sha256 "87c8e7a7fa0c68ab28e208ba49f3a22a56000dbf53a6f90206e2bc5843931cc4"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e86203eb8b102da96476cf4b1f733753b7aaa9aa07da15a99166525e05f29165"
    sha256 cellar: :any,                 arm64_big_sur:  "62d52d9f5bec06079f1ae8c7463acc7a08b595e1f23dd8aebd26cc9805a6e075"
    sha256 cellar: :any,                 monterey:       "f36017168dc933bea4241cae9d327154d162be859df4645297b014a7c4b2835d"
    sha256 cellar: :any,                 big_sur:        "6a6fd8d58bfc45afa6d4f1700f500acedb533cfe8d3d60ce1a5769dbeff37c23"
    sha256 cellar: :any,                 catalina:       "951d67f3a26a6e4646e9aea57baabd4061eca61f0bd8f7ac4747fb9610aedca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17185e07288cf7f6a2c2cdb0e1657a05307670d5814f80268897fff013417dc"
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
