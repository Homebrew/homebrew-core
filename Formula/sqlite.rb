class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2022/sqlite-autoconf-3380100.tar.gz"
  version "3.38.1"
  sha256 "8e3a8ceb9794d968399590d2ddf9d5c044a97dd83d38b9613364a245ec8a2fc4"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a2a290274b7e7d01fbc927c539acd3f5414fd69d5d907e4f027716808c7c8496"
    sha256 cellar: :any,                 arm64_big_sur:  "6c6c16fa006b4cb0262d88440d56feb106b81ac078c6bfff76e37f77725036b9"
    sha256 cellar: :any,                 monterey:       "b8406d033e4e02c2365de2bd842e51fba02bc1b5555879d316593fe2265cb488"
    sha256 cellar: :any,                 big_sur:        "b9ac20be25eccc09af46bc6c04adb628f08282764c243fcd34a0eaadc60af45b"
    sha256 cellar: :any,                 catalina:       "29fc15cfa2d5a90ab9e1f8104231bbed3dd83e420b1c6ed7236d5d47963855b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69268874a6acc19146d8c34cf4f835b9de60f339946882cf03227c256ede7818"
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
