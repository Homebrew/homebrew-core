class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.7.tar.gz"
  sha256 "e8c5c369f502451f29905267b5223e5cf49b16de89667f24c70207007e1bfffc"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fee6f1529c495107bc367143d7d66c683f2deae9eaa0dd19f536911e32a6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fee6f1529c495107bc367143d7d66c683f2deae9eaa0dd19f536911e32a6ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1fee6f1529c495107bc367143d7d66c683f2deae9eaa0dd19f536911e32a6ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "cedb49149f487b1eec11e9d98612ebc6f62ca61be11c0ca636524a1ac494a4d9"
    sha256 cellar: :any_skip_relocation, ventura:       "cedb49149f487b1eec11e9d98612ebc6f62ca61be11c0ca636524a1ac494a4d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfa338fdd0af66059c0416a934d900c93eb74b72219257e95800c779603791a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfa338fdd0af66059c0416a934d900c93eb74b72219257e95800c779603791a1"
  end

  depends_on "python@3.13"

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
    data.each_slice(2) { |n, a| assert_match "#{n},#{a}", output }
  end
end
