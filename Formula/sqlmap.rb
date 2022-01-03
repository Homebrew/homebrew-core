class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.tar.gz"
  sha256 "78c654fbffc4af710f11d2be614e198fb5b13e526dd38c960048ae1eadffaf29"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8c215043ba5fcf2e2a338f66c190a151465e41f5b9d4744d22acb226e2c80a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8c215043ba5fcf2e2a338f66c190a151465e41f5b9d4744d22acb226e2c80a7"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f3f394ead0c2e8d7af12eaea3bf6b126d0f0d9338589697fca6b88b1a31fdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4f3f394ead0c2e8d7af12eaea3bf6b126d0f0d9338589697fca6b88b1a31fdb"
    sha256 cellar: :any_skip_relocation, catalina:       "b4f3f394ead0c2e8d7af12eaea3bf6b126d0f0d9338589697fca6b88b1a31fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1057c5aaa1b00f3ce06b20a2194825755aa44956e1880af4e03d7bfb452207a"
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
