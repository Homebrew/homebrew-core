class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3390200.tar.gz"
  version "3.39.2"
  sha256 "852be8a6183a17ba47cee0bbff7400b7aa5affd283bf3beefc34fcd088a239de"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8b1ae9f882330df5e521dd95856b442e19c163e55a4da23b3fc42915df7a717"
    sha256 cellar: :any,                 arm64_big_sur:  "0f1857a5b00b477cbc71f4e8b47db0909ac4591ed162fa68b85bb0b2366a2f74"
    sha256 cellar: :any,                 monterey:       "faba8d1938f5f378e3936203a8987365a39907227df366a63fedf8ef174b4394"
    sha256 cellar: :any,                 big_sur:        "73e2404794105ffc14879b2604ba399fbe65050b5eefe50729f7a8d77300f646"
    sha256 cellar: :any,                 catalina:       "dec681d069d2e1aa82f8f969824d0d85a30e8d12ed9b65046c9ca90235ab1240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7c81a07dbc720fd921da3abb096363cc24d600105b85c46a010b58ce0883ee0"
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
