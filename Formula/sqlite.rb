class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3410200.tar.gz"
  version "3.41.2"
  sha256 "e98c100dd1da4e30fa460761dab7c0b91a50b785e167f8c57acc46514fae9499"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a77f2ddcf124d8704c299572c4dc55517996d796011545852e362c6e2a2a2ea"
    sha256 cellar: :any,                 arm64_monterey: "9cf3cb233b600ac26cd090a475dfebc99cfe25620ad2b76fadb3c81c01038fe3"
    sha256 cellar: :any,                 arm64_big_sur:  "78d4c5470ab9287a5abc1f3d8bafe92d6d416ec375cbd3650ecb26ff1b0531ae"
    sha256 cellar: :any,                 ventura:        "1d86064177dc844cfa23ddf9c857c4f8171bc6c232ba494e02df3b0ddddf4f07"
    sha256 cellar: :any,                 monterey:       "a4f10bac36c302931738f59315eac2bb068c8e35066dc23ba5b47141779751cd"
    sha256 cellar: :any,                 big_sur:        "5fb0686e712e6623bee8bc1ef2cac08585fba4a6e5b3d5962b4a8f1f22c11edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e14436989a1cf1a51b5122c9499c8730713757225ef4ac1916d6ec508caa8dda"
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
