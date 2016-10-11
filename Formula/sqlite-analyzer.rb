class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2016/sqlite-src-3140200.zip"
  version "3.14.2"
  sha256 "52507e20c2757b24b703b43ede77ce464c8106c1658a5b357974c435aa0677a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "263334b6f85ba014bd9dc0af7da32f57e0ddae302d392adb6cdcd94a9b302206" => :sierra
    sha256 "5e65b3bff1022c0ce2686676c1a530d6763d58161ba6bd689dedcc574ec43b68" => :el_capitan
    sha256 "4de22444bd4dcd4368c81ee4c7679110d6f708bc08e7f2a278435b11b2ebd9d3" => :yosemite
    sha256 "6da145e5c3b3481659d6ff6b80f48621541eb11b8d59de12fd2e2df3d0683001" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
