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
    sha256 cellar: :any,                 arm64_monterey: "debcf87141c39a5902b5142d64b1d91935677eb44f9838d60e52abc37a42a31e"
    sha256 cellar: :any,                 arm64_big_sur:  "ee147de3d4d57624ffc26e230806cb2d8a99524f22401fbef8049e0b8b41c9b9"
    sha256 cellar: :any,                 monterey:       "263146083f3cffb859312957fbb6b4dd8a11c87dafe22f3d3712d39566dfd026"
    sha256 cellar: :any,                 big_sur:        "bf63198a72c33149f4d58a1004a189d176a0e135949e3d6e8ec96a7301de6caf"
    sha256 cellar: :any,                 catalina:       "b3abf39f3b606267be4f712973e5fe5e693bc6aafcea3fe2d9a259482717a1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23897fa4059f171f81d329fd9b52ad7d3c301e70f76619ac23e24e6673022f22"
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
