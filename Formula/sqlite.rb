class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3380500.tar.gz"
  version "3.38.5"
  sha256 "5af07de982ba658fd91a03170c945f99c971f6955bc79df3266544373e39869c"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a183a88ceba293d2d05139580e4eaa28834a6cb94845154172d353dbb6f809a1"
    sha256 cellar: :any,                 arm64_big_sur:  "e3c7de8c3160c18166e7d636011374e7afa1c6e6b164848c7f4c92ee3ce9ada5"
    sha256 cellar: :any,                 monterey:       "0bf58c32e0ff8c2c6dc2bcd789f6864969024033c1ba151d98c14189e10ab1b0"
    sha256 cellar: :any,                 big_sur:        "a00f91bc07c86b27fef50ed7d376cb1f623c24d882658ac6e1b75a793a60e8db"
    sha256 cellar: :any,                 catalina:       "c69ec0f7a26cadf2ffd8a99f1a14ade16c96ea5db2d786d28800d61f3b3ab78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232e6263d1d228f320b8bfab88200a2ba085bc450f6fa2003076eb54428fc5e1"
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
