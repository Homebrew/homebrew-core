class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.11.tar.gz"
  sha256 "69b91d6bba6d053b300a89692d5ebe98cc3ce9803d5f25e600a31943afa7fc6e"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e664309b75817cd5f20479354c423452de5e222305c2faf34e444b220f52cbbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e664309b75817cd5f20479354c423452de5e222305c2faf34e444b220f52cbbd"
    sha256 cellar: :any_skip_relocation, monterey:       "630cbd04f0c49fbfc5a367a3229fb47dfc39dbcaf554aee4fe58cd04e0cc640a"
    sha256 cellar: :any_skip_relocation, big_sur:        "630cbd04f0c49fbfc5a367a3229fb47dfc39dbcaf554aee4fe58cd04e0cc640a"
    sha256 cellar: :any_skip_relocation, catalina:       "630cbd04f0c49fbfc5a367a3229fb47dfc39dbcaf554aee4fe58cd04e0cc640a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a910cf0644e3aaf7f9259356630270f38ccbeccc3f2395853511797130a9272d"
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
