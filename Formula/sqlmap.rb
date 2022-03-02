class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.3.tar.gz"
  sha256 "a099cde73f57ba9e70ad7dd2f7473202a02929766471fc5701f64f2c16b304c2"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acc6d1b1e8c2b7bc44ce1a119d3f1bea26cf3724bd196624dc4c7c8259416287"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acc6d1b1e8c2b7bc44ce1a119d3f1bea26cf3724bd196624dc4c7c8259416287"
    sha256 cellar: :any_skip_relocation, monterey:       "b6cbb6dfeba41dea7e795f8b7637f1b344093e151f99c2f402d00e6a8ecb3d54"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6cbb6dfeba41dea7e795f8b7637f1b344093e151f99c2f402d00e6a8ecb3d54"
    sha256 cellar: :any_skip_relocation, catalina:       "b6cbb6dfeba41dea7e795f8b7637f1b344093e151f99c2f402d00e6a8ecb3d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b2bda01048d708f132742132fa9e71e85a2c061655d953505c7ceaea1f13b9"
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
