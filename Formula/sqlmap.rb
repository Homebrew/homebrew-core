class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.8.tar.gz"
  sha256 "a4302858bcf7791334e8f7165885369898330aa547888db0e73576b53f96771d"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3b409785b9e4fb5f3a6f11c8be9c859f222b4dd64bff4d81e4d80195f66bb03"
    sha256 cellar: :any_skip_relocation, big_sur:       "f75599f7a49b4a0a10c201a3b9874c5f45fd6bda26ba96855e687103a1fbb9b3"
    sha256 cellar: :any_skip_relocation, catalina:      "f75599f7a49b4a0a10c201a3b9874c5f45fd6bda26ba96855e687103a1fbb9b3"
    sha256 cellar: :any_skip_relocation, mojave:        "f75599f7a49b4a0a10c201a3b9874c5f45fd6bda26ba96855e687103a1fbb9b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3078d54361bde6f22fc6e0e0b6a35e94b334e11994aaf5ae513ffee5d42937"
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
