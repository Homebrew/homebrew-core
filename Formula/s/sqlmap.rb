class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.9.tar.gz"
  sha256 "3ae9969bec583d21790c5282aa3e586bf8fa822ad5d267afb7ea19db07ac434c"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed538d5d94689af0004d329f50811988486039929bf0f9aa55a170e1a655f9e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed538d5d94689af0004d329f50811988486039929bf0f9aa55a170e1a655f9e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed538d5d94689af0004d329f50811988486039929bf0f9aa55a170e1a655f9e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9165aa3e6e152d473c1b6777a3ed50190c4bb441f40d8f95a0e4f1acd6cf036"
    sha256 cellar: :any_skip_relocation, ventura:       "a9165aa3e6e152d473c1b6777a3ed50190c4bb441f40d8f95a0e4f1acd6cf036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527f10583500cbfe99d8cb961169eae794c66b388340765b845506e1dc42524b"
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
    data.each_slice(2) { |n, a| assert_match "#{n}, #{a}", output }
  end
end
