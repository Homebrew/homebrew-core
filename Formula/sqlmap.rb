class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.9.tar.gz"
  sha256 "3e8516e268ffc6983ff522f7d5a73327e2ad0156c256d713ba046a4b7df3ef94"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8520f1f0c04fda852d13d362803aacdf620cb774ca93b0216eb0e02a9487d9d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "85333509941be1b99beaa308b62fd05cd1ff156ed626f4137983f6409f890fce"
    sha256 cellar: :any_skip_relocation, catalina:      "85333509941be1b99beaa308b62fd05cd1ff156ed626f4137983f6409f890fce"
    sha256 cellar: :any_skip_relocation, mojave:        "85333509941be1b99beaa308b62fd05cd1ff156ed626f4137983f6409f890fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "166bb40f916355b31d46eaabb449ad018667e01c8ca41ca23184dc96d02855bd"
  end

  depends_on "python@3.9"

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
