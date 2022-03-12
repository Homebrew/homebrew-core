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
    sha256 cellar: :any,                 arm64_monterey: "99e45b4eb6dbd7d0c2f341ad910436a27a753d5025ca7cc929cc58c0342ee40b"
    sha256 cellar: :any,                 arm64_big_sur:  "44a08d0fc08f943c93e392a4b0f02dac063ab0eeec2cecaab5cbde48c85b435d"
    sha256 cellar: :any,                 monterey:       "9e77132d9e64fcca7abb562cf6980ce578f961041187dbf84b6d1d85eb2388a2"
    sha256 cellar: :any,                 big_sur:        "6ffd1aaefe4260bbef922a2547a8084c6659c6f90cc60ddae4a4b736960f36d2"
    sha256 cellar: :any,                 catalina:       "99bd4062c849583024efbddf8b0d45ca149cbd9cc233b7db50914aac46d48b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d150333b1f8d274df775f79a684f983f5f0e1334016c056c77d09e336b0889df"
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
