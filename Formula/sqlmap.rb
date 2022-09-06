class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.9.tar.gz"
  sha256 "bccf1bea6ce44777a860ecbcaa83773889de023aeb51266cdbe961b7dc7732ba"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "406d22a7e48573a795635b2f3959dd5001f900f4ba6fb99e70c7e6aee250f109"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "406d22a7e48573a795635b2f3959dd5001f900f4ba6fb99e70c7e6aee250f109"
    sha256 cellar: :any_skip_relocation, monterey:       "10c0dec18ef03aa52507bb3ec9b45e4395559067dc49070bf1db93fef567e48e"
    sha256 cellar: :any_skip_relocation, big_sur:        "10c0dec18ef03aa52507bb3ec9b45e4395559067dc49070bf1db93fef567e48e"
    sha256 cellar: :any_skip_relocation, catalina:       "10c0dec18ef03aa52507bb3ec9b45e4395559067dc49070bf1db93fef567e48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3363ae2bfe6e96437df971b75ebcd6a353dc3f45d2d466d7b5215734e6b1777c"
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
