class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.2.tar.gz"
  sha256 "58db9fb0a79332927634cdb8de6df7e62997ec85b77daef0ce733612a1d79de1"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f78c876e31c3d6d1da72ab159e9cd173bc5de9b85bb91d92d4af4399c0f637c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f78c876e31c3d6d1da72ab159e9cd173bc5de9b85bb91d92d4af4399c0f637c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f78c876e31c3d6d1da72ab159e9cd173bc5de9b85bb91d92d4af4399c0f637c"
    sha256 cellar: :any_skip_relocation, ventura:        "59ff1490cb1bcd310f57c564eaa766d7c5bf81c7e30022584152ec6247b3e990"
    sha256 cellar: :any_skip_relocation, monterey:       "59ff1490cb1bcd310f57c564eaa766d7c5bf81c7e30022584152ec6247b3e990"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ff1490cb1bcd310f57c564eaa766d7c5bf81c7e30022584152ec6247b3e990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5254bdecaa42d5f48ce7b3f10ba962d10d55e57749fa1aa22c9c05f04f70bed6"
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
