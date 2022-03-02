class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.3.tar.gz"
  sha256 "a099cde73f57ba9e70ad7dd2f7473202a02929766471fc5701f64f2c16b304c2"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "442bfda28837e573de966c432ac35b725658801f62c3c74bbb001a76309a79a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "442bfda28837e573de966c432ac35b725658801f62c3c74bbb001a76309a79a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f399c0061155c869e96a634ad974e11007210ea9def09ad25987a062af5e49e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f399c0061155c869e96a634ad974e11007210ea9def09ad25987a062af5e49e2"
    sha256 cellar: :any_skip_relocation, catalina:       "f399c0061155c869e96a634ad974e11007210ea9def09ad25987a062af5e49e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93faea240f5f84b5885e82994859056a2d0e2e4c7f318e2e9681010f1707747f"
  end

  depends_on "python@3.10"

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
