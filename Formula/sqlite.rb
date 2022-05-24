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
    sha256 cellar: :any,                 arm64_monterey: "ec526591d77541ae811e1d91381e5c109e5110ec8643bd3ba394f025be1b32ef"
    sha256 cellar: :any,                 arm64_big_sur:  "d42e20a3f7b0b69c202173b9f71ba0e4ffdcfddda45b19eb643258420d56b061"
    sha256 cellar: :any,                 monterey:       "93880cd7f1542905357378678f0737ef8a4148eb0d292e752e80a4e6c67a6ec1"
    sha256 cellar: :any,                 big_sur:        "2995647a720c4e9a0d2b415982c37898fa841f6c5dd1494242c7edafc2cec2f0"
    sha256 cellar: :any,                 catalina:       "b3814e42288e78f2a3ae827e6d976e610ca9140b9fdec3ae0d6586ea243224c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e692c3eecc65466abd39ac527905770dfe5f5f4d04d38521911c5ab666cbf8c5"
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
