class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3370200.tar.gz"
  version "3.37.2"
  sha256 "4089a8d9b467537b3f246f217b84cd76e00b1d1a971fe5aca1e30e230e46b2d8"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e9774179ea081aa6b4d1ac4f0ff909918e746ab112415f20bc1ce9ab2e71524"
    sha256 cellar: :any,                 arm64_big_sur:  "2cfc5aa33ad0dc40144efcca1f333f39f64c7e22bbcaf6e251eda247e5366a07"
    sha256 cellar: :any,                 monterey:       "8bb9bda5a0915f5fa0e5465ddd14e74962f56c0d1d8250d3c827322520e0d3e1"
    sha256 cellar: :any,                 big_sur:        "7f734acce1459afa08637461e97eaf1eea571587e363ea16953d48dff21b5a1b"
    sha256 cellar: :any,                 catalina:       "d1000e32424de78b2ade9ac9e0605989b026d97fdf9074e40f3969e544d59281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540840fa28739d52f563dfebef9d28fa8d0a7460297dc8b846b7b83419ace4f4"
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
