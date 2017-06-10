class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3190300.zip"
  version "3.19.3"
  sha256 "5595bbf59e7bb6bb43a6e816b9dd2ee74369c6ae3cd60284e24d5f7957286120"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fb8a118450c995da8dee40ebb26d08a9a87658b08b17c59e916a839cdabe594" => :sierra
    sha256 "4878a210d568a56ab6b95d08e8d421002eded5b7d6ed6ef9d10ee4cbd70256b6" => :el_capitan
    sha256 "337eb380e1a789378b5746f0279e806b1de7317073fb434e5df9fe633bc99ae7" => :yosemite
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
