class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.9.tar.gz"
  sha256 "6fb835a4c1514dd7dd1047e83001a746d95abfa341e559cdd08f73eb84aae96d"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74089bb68fd0569194235aea2736899bd8a1e3b94d733365047734000202e98f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74089bb68fd0569194235aea2736899bd8a1e3b94d733365047734000202e98f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74089bb68fd0569194235aea2736899bd8a1e3b94d733365047734000202e98f"
    sha256 cellar: :any_skip_relocation, ventura:        "7cdcfe492cbee0fa7e22c6244237d5d36266333215349313d9cdef54358297bf"
    sha256 cellar: :any_skip_relocation, monterey:       "7cdcfe492cbee0fa7e22c6244237d5d36266333215349313d9cdef54358297bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cdcfe492cbee0fa7e22c6244237d5d36266333215349313d9cdef54358297bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddfe260de08abbfdc24ad8c6726986f11169ae0fc215653e416244e973952d2d"
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
