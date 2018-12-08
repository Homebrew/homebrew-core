class Sqlmap < Formula
  desc "Penetration testing for SQL injection and database servers"
  homepage "http://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.2.12.tar.gz"
  sha256 "c8f4e911fa70b3b70cb22645f2433500026a2af7e254f03e7ea8c64af67c4b84"
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
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "CREATE TABLE students (name TEXT, age INTEGER);\n"
    data.each_slice(2) do |name, age|
      create << "INSERT INTO students (name, age) VALUES ('#{name}', '#{age}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "SELECT name, age FROM students ORDER BY age ASC;"
    args = %W[--batch --dbms=sqlite -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |name, age| assert_match "#{name}, #{age}", output }
  end
end
