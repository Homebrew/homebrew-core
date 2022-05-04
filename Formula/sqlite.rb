class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3380400.tar.gz"
  version "3.38.4"
  sha256 "1935751066c2fd447404caa78cfb8b2b701fad3f6b1cf40b3d658440f6cc7563"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8691541c36bbb0d7fed59d98d4eff7908762c079e2aefb9994b6f2e21710b3c2"
    sha256 cellar: :any,                 arm64_big_sur:  "2a60175e7f2ba40dfa5eb9f015fcf52761ab6b2ecf132a69ad9bfad391f7dd1b"
    sha256 cellar: :any,                 monterey:       "53c1dc09cb3e34f85ce5b20937ad5429115822c473cfead02fb7a0dbbb8fabbc"
    sha256 cellar: :any,                 big_sur:        "ef58d1c3319cc089eab67e19fd430526da7b36efa7d9bbc24167f999103490c7"
    sha256 cellar: :any,                 catalina:       "cf612e46ece07030af144bf0302f6121c1374981dea2233a3d6aaf11695ba5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33fb42e4a4db32edbde659ff5fe8a83ac0fbe75d9b43b50c7693f3e8e71dd99d"
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
