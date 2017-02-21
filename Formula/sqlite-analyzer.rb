class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3170000.zip"
  version "3.17.0"
  sha256 "86754bee6bcaf1f2a6bf4a02676eb3a43d22d4e5d8339e217424cb2be6b748c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "893afee1f93e28e25351b2b426490fb889494330d2547e63f0d45afd4da56040" => :sierra
    sha256 "e1d7234ef0a619c3b1653c29b204c9813e59b3ff6b0d2f15801c86847ef5af38" => :el_capitan
    sha256 "512ca3e4b923cdb65ff62c49608bd3b61df2e0bbbc1d4a50ca71131b3941b825" => :yosemite
  end

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_DISABLE_INTRINSIC" if MacOS.version <= :yosemite && ENV.compiler == :clang
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
