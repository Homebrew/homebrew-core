class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.3.tar.gz"
  sha256 "abb642b399c7fcedf2af0c1c717c7f0fa4a716a2053a538250375fb53c6333c4"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05783bb9a01d23df4cd73db21b7d04d06e2c29241d9d9adcd15b1902b65bcd92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05783bb9a01d23df4cd73db21b7d04d06e2c29241d9d9adcd15b1902b65bcd92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05783bb9a01d23df4cd73db21b7d04d06e2c29241d9d9adcd15b1902b65bcd92"
    sha256 cellar: :any_skip_relocation, ventura:        "0a95286beba62c5af237946634d2d4867d54230658b9b1c9dd40c1050ec0b9b5"
    sha256 cellar: :any_skip_relocation, monterey:       "0a95286beba62c5af237946634d2d4867d54230658b9b1c9dd40c1050ec0b9b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a95286beba62c5af237946634d2d4867d54230658b9b1c9dd40c1050ec0b9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799165d2d19649a95d9485591c46dab1d7c5c06d59bfd188b84fdecf5dc828a6"
  end

  depends_on "python@3.11"

  uses_from_macos "sqlite" => :test

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang, libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end
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
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end
