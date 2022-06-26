class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.6.tar.gz"
  sha256 "3111017165f0dacdd6a83800b02ef27b17cdb5b31d19eebe44436aaac935f186"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2905048e828446969572c140b590ab5034072f1611a7af8984b87b5eaddaeb93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2905048e828446969572c140b590ab5034072f1611a7af8984b87b5eaddaeb93"
    sha256 cellar: :any_skip_relocation, monterey:       "c9875b85a430bfc0093d0fdeb194f16d578715d85bc642d88acfc138ac87800c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9875b85a430bfc0093d0fdeb194f16d578715d85bc642d88acfc138ac87800c"
    sha256 cellar: :any_skip_relocation, catalina:       "c9875b85a430bfc0093d0fdeb194f16d578715d85bc642d88acfc138ac87800c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae69758384a5033a4c1a0ba66c8f277e4b5192d2646c4461016f5f15e998ae25"
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
