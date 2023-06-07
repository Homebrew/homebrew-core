class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.6.tar.gz"
  sha256 "035df3f8d3eda65723318d3e1faa5e271e82774a151f4ff706e79ed5b49e2b27"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d45aaa7e2b243ec089180ead3af515b60cde65042e3bc2c2e5238488b7c02cdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d45aaa7e2b243ec089180ead3af515b60cde65042e3bc2c2e5238488b7c02cdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d45aaa7e2b243ec089180ead3af515b60cde65042e3bc2c2e5238488b7c02cdc"
    sha256 cellar: :any_skip_relocation, ventura:        "2981642da641b4e2882a37340d8af8390fdd22c02efad3217e9cf2f2fe88b38a"
    sha256 cellar: :any_skip_relocation, monterey:       "2981642da641b4e2882a37340d8af8390fdd22c02efad3217e9cf2f2fe88b38a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2981642da641b4e2882a37340d8af8390fdd22c02efad3217e9cf2f2fe88b38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c36e56f7cbba34cb6842b4b7ca87e2e94501d02cc0c7384dd06e6572aedb88e"
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
