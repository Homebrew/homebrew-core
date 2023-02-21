class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://www.sqlite.org/2023/sqlite-autoconf-3410000.tar.gz"
  version "3.41.0"
  sha256 "49f77ac53fd9aa5d7395f2499cb816410e5621984a121b858ccca05310b05c70"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e19a160e1012ed0d58f0e1f631d6954c2bb6feb3cf9f8e9417d6f8955b81236d"
    sha256 cellar: :any,                 arm64_monterey: "45f18a632fd523c325bedda31a17ec8a1e577da0c4350b0342106ce360a925a5"
    sha256 cellar: :any,                 arm64_big_sur:  "1dce645628978038d4615669728089f9e22259a8c461f5d81672b741189f1f29"
    sha256 cellar: :any,                 ventura:        "d3092d3c942b50278f82451449d2adc3d1dc1bd724e206ae49dd0def6eb6386d"
    sha256 cellar: :any,                 monterey:       "ebdcd895a537933c8ae0111a96b02aa7e2ac8f8c991f0c3e4d9ec250619a29e5"
    sha256 cellar: :any,                 big_sur:        "c2b7d4f849d7af7e8be3c738e9670842c9c6b25053fd19a90ef8264b2a257158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1baebd808a5cdb47c3fedbefd4de5cf7983700c41191432f3a9bed4885bb06"
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
