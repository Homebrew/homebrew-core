class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3400000.tar.gz"
  version "3.40.0"
  sha256 "0333552076d2700c75352256e91c78bf5cd62491589ba0c69aed0a81868980e7"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed03ca23cc8611bb88ce29c7e0ae67d46fbe198882c68f620e620a6d47efd869"
    sha256 cellar: :any,                 arm64_monterey: "f1c794d049edb88bcfae5ea21e1059c565eb423f49d47018979af4ace704b739"
    sha256 cellar: :any,                 arm64_big_sur:  "1e495b0589f81c170d3eaa5fa2378b29f5b8efddc6204936433c96cd7b722ca2"
    sha256 cellar: :any,                 ventura:        "461d8c0ba2912139511e4315dd053c9a28010f63787a003dadea0e62cb554446"
    sha256 cellar: :any,                 monterey:       "8106dacddb56d76e1c485a1c30e8c0659cbd02152134420729a22ba8cfcb468c"
    sha256 cellar: :any,                 big_sur:        "cf2aaa808a7590a16af58d908f4fa16e9b17d0e602675cdcfa6913daceabf0a1"
    sha256 cellar: :any,                 catalina:       "ab944529d5bd93dd592f25dd499de7183550d678fd3264e90411f35b278673fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9e2484df239ad3deea6baac5225bded7cc4fb2dbf9cfda068d0e37272f32f7"
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
