class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.4.tar.gz"
  sha256 "14585e4fc95006467e52685c4838f024654d7e23cbd84eb12762a55918b8d561"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01695368a1a603a12720787e67d7c9624e63696550a1f4563049da400be2b710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01695368a1a603a12720787e67d7c9624e63696550a1f4563049da400be2b710"
    sha256 cellar: :any_skip_relocation, monterey:       "acee8fd18b18cd509e1ae6757284c7b54fd4eb483e7a48e181e04fd16a7aa2c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "acee8fd18b18cd509e1ae6757284c7b54fd4eb483e7a48e181e04fd16a7aa2c2"
    sha256 cellar: :any_skip_relocation, catalina:       "acee8fd18b18cd509e1ae6757284c7b54fd4eb483e7a48e181e04fd16a7aa2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "087b897322fb0312a5d95a6bd1d04ea6c2d4fce74496e933e4cb2e0380f277bf"
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
