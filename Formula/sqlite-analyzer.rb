class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://sqlite.org/2018/sqlite-src-3220000.zip"
  version "3.22.0"
  sha256 "7bc5a3ce285690db85bd3f97034a467e19096b787c9c9c09a23b1513a43c8913"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc2800e367603b71a8b94d912f0f9c7edfb1a097776fab42051ecf5c9787bfe1" => :high_sierra
    sha256 "97b206578f833767e62786f25078448b4ca97a23f51415ebc783fcac373dffd9" => :sierra
    sha256 "aea3b08fa1c38cd864c21f41848544a23924e750d566f5b6a62e0ea1076959a5" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--with-tcl=/System/Library/Frameworks/Tcl.framework/", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
