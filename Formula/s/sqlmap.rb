class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.2.tar.gz"
  sha256 "84f51ffb7486e3b13bc16676fdaeca8380089c6faa131c18d9bfcd5418501644"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3215e75e71b2067963dbe468b232159eac5bdad8f4798f332c073ef8070580d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3215e75e71b2067963dbe468b232159eac5bdad8f4798f332c073ef8070580d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3215e75e71b2067963dbe468b232159eac5bdad8f4798f332c073ef8070580d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "658680b8ef780df167f0d80216dbe2491e2bf6ba2adfa9757afc475304337238"
    sha256 cellar: :any_skip_relocation, ventura:       "658680b8ef780df167f0d80216dbe2491e2bf6ba2adfa9757afc475304337238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9565c1be35a6c340d65703e749afb06cd009c06e8bba98ae079b22d5666e7e28"
  end

  depends_on "python@3.13"

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
    data.each_slice(2) { |n, a| assert_match "#{n},#{a}", output }
  end
end
