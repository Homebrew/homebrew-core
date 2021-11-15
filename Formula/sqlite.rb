class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/index.html"
  url "https://sqlite.org/2021/sqlite-autoconf-3360000.tar.gz"
  version "3.36.0"
  sha256 "bd90c3eb96bee996206b83be7065c9ce19aef38c3f4fb53073ada0d0b69bbce3"
  license "blessing"

  livecheck do
    url :homepage
    regex(%r{href=.*?releaselog/v?(\d+(?:[._]\d+)+)\.html}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "87acc578c27c3e9b21013e1186cf95e9de830886f8dbbb34bf22ca1fe3ec460a"
    sha256 cellar: :any,                 arm64_big_sur:  "b7d98dc89e39bfd68676ce9df2e58d78e790a2591ef204800b27a454c019024a"
    sha256 cellar: :any,                 monterey:       "7c973f46e727f8b9e6d6c596900558168da4bffb625d7b103607eaa76c65cb20"
    sha256 cellar: :any,                 big_sur:        "2c9c5f05c16c1fa972fc49c4b2705d7877b99640b6bb0b3908333e17f63dd71b"
    sha256 cellar: :any,                 catalina:       "3665b75356219a7823309efad0304b40bbccc369576685e8faef280a539e8600"
    sha256 cellar: :any,                 mojave:         "f96b12f3fe9b69283cb786aee0d034370cb2407a076f58f20e19de08745d58c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8faf56c6f089b2538a86678652af07da8eb0db8000e684e875c1ef12be011e"
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
