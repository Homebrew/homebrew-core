class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2016/sqlite-src-3150100.zip"
  version "3.15.1"
  sha256 "423a73936931c5148a4812ee7d82534ec7d998576ea1b4e1573af91ec15a4b01"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e02ed49fe3ac2be94ba814d0b7ac500baa71dcd60b93eb294c563ce3d58c3a5" => :sierra
    sha256 "62f065d3cf2eb3a82d3878656a9af1bfa7be9f926952b33eab505716e0c17852" => :el_capitan
    sha256 "cd73d6776a26c2746bb298024078b7b450112bb124eda991369b2f08798b923e" => :yosemite
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
