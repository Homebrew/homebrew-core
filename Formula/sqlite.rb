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
    sha256 cellar: :any,                 arm64_monterey: "a784162db8884acde9081649ae2777abe75b2e7c8072f6a1f646c3c72b43c6fd"
    sha256 cellar: :any,                 arm64_big_sur:  "2affd69135c3a45b0671d98f5375845c29f74955ba62481ed99fe3289691e544"
    sha256 cellar: :any,                 monterey:       "db6a8d19c87a59b8f8e6fa096e2607da935cf4df9b816a74c455776be8151fdd"
    sha256 cellar: :any,                 big_sur:        "d6f159809c71843d3782f35b4271128b3db7d3ce92b941ba707d7c688be52536"
    sha256 cellar: :any,                 catalina:       "d1726ae48132d39f158e58865bbeeedbf77082dbe0977140b58451b0a0733749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36e67b8ba3b97fa1cab4fda0aa2af3825c45fa72e0d9d6f75f6ccbbae3afce41"
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
