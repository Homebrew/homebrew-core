class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.8.tar.gz"
  sha256 "a4302858bcf7791334e8f7165885369898330aa547888db0e73576b53f96771d"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7349c40c6f7c11ccc54e7af0f57de818e0a9c52eef172599f9b94f497c3723c7"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebc7bf500d27486902f532ab0883ccb0e094dfdcf27ef7794590de71c505ea98"
    sha256 cellar: :any_skip_relocation, catalina:      "ebc7bf500d27486902f532ab0883ccb0e094dfdcf27ef7794590de71c505ea98"
    sha256 cellar: :any_skip_relocation, mojave:        "ebc7bf500d27486902f532ab0883ccb0e094dfdcf27ef7794590de71c505ea98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1529730aa9501efd6375874f83447d62b791097e0fedfef3a821758ed1be27ff"
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
