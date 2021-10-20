class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.10.tar.gz"
  sha256 "7147ba8c9ac98fe55daa4928c34f7b6e314bfa7fa60a4f073689f70533128bcb"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bcadbc807985338e0d0bba23e9525b7446a2dbd3ce6add55a3d5eef50d624355"
    sha256 cellar: :any_skip_relocation, big_sur:       "b079ef5e78fd53a75fcd9c038b8c7fa0752f454105b21d60cfe6cfc7f2aa9b21"
    sha256 cellar: :any_skip_relocation, catalina:      "b079ef5e78fd53a75fcd9c038b8c7fa0752f454105b21d60cfe6cfc7f2aa9b21"
    sha256 cellar: :any_skip_relocation, mojave:        "b079ef5e78fd53a75fcd9c038b8c7fa0752f454105b21d60cfe6cfc7f2aa9b21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "344b73aa1fa7760a3a16ec47ee58b57e66307a6f41d360731113302b9e4b85d0"
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
