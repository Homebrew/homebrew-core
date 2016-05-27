class Sqlmap < Formula
  desc "Penetration testing for SQL injection and database servers"
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.0.5.tar.gz"
  sha256 "e402ee38ff4677439d831265604a2b197af7f0f90f381001efbb4558b77218c2"
  head "https://github.com/sqlmapproject/sqlmap.git"

  bottle :unneeded

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"sqlmap.py"
    bin.install_symlink bin/"sqlmap.py" => "sqlmap"

    bin.install_symlink libexec/"sqlmapapi.py"
    bin.install_symlink bin/"sqlmapapi.py" => "sqlmapapi"
  end

  test do
    query_path = testpath/"school_insert.sql"
    query_path.write <<-EOS.undent
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS

    query_select = "select name, age from students order by age asc;"

    # Create the test database
    `sqlite3 < #{query_path} school.sqlite`

    output = `#{bin}/sqlmap --batch -d "sqlite://school.sqlite" --sql-query "#{query_select}"`
    assert_match /Bob,\s14/, output
    assert_match /Sue,\s12/, output
    assert_match /Tim,\s13/, output
  end
end
