class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.10.tar.gz"
  sha256 "aea3bf921d9a2466bc0e33cf43bc941f527eabf7981ec1de104220def3a1cba4"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5160948123e8e2554a4df905929c06173341196b3b0ac66fb4fd40d99a297155"
  end

  depends_on "python@3.14"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end

    # Build an `:all` bottle
    inreplace libexec/"thirdparty/magic/magic.py", "/usr/local/Cellar", "#{HOMEBREW_PREFIX}/Cellar"
    inreplace libexec/"lib/core/dicts.py", "/usr/local/var/www", "#{HOMEBREW_PREFIX}/var/www"
    inreplace libexec/"lib/core/settings.py", "/opt/homebrew", HOMEBREW_PREFIX
  end

  test do
    data = %w[Bob 14 Sue 12 Tim 13]
    create = "create table students (name text, age integer);\n"
    data.each_slice(2) do |n, a|
      create << "insert into students (name, age) values ('#{n}', '#{a}');\n"
    end
    pipe_output("sqlite3 school.sqlite", create, 0)
    select = "select name, age from students order by age asc;"
    args = %W[--batch -d sqlite://school.sqlite --sql-query "#{select}"]
    output = shell_output("#{bin}/sqlmap #{args.join(" ")}")
    data.each_slice(2) { |n, a| assert_match "#{n},#{a}", output }
  end
end
