class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.11.tar.gz"
  sha256 "7c10a92591f440678af7eaf07c439a331c79a86e44588e32cbce490ab731bafe"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8e7eb6ad31bd7c66ee44ce68bbac8e475ea4a1c37e36c2d52bcb78280ebf5db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8e7eb6ad31bd7c66ee44ce68bbac8e475ea4a1c37e36c2d52bcb78280ebf5db"
    sha256 cellar: :any_skip_relocation, monterey:       "59ca8baa6c06583a195dba12e1b39fecb76afba8f18fc0a1c17e5a8017505141"
    sha256 cellar: :any_skip_relocation, big_sur:        "59ca8baa6c06583a195dba12e1b39fecb76afba8f18fc0a1c17e5a8017505141"
    sha256 cellar: :any_skip_relocation, catalina:       "59ca8baa6c06583a195dba12e1b39fecb76afba8f18fc0a1c17e5a8017505141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c1ea18283c5a23c8661ac745abcd66f65308af25a1bef7809dd8421b8d3e1ca"
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
