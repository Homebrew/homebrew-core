class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.tar.gz"
  sha256 "78c654fbffc4af710f11d2be614e198fb5b13e526dd38c960048ae1eadffaf29"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21ee913a28109bba73c62b2007d88161a9b8b0433e8254764de35612bc65b252"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21ee913a28109bba73c62b2007d88161a9b8b0433e8254764de35612bc65b252"
    sha256 cellar: :any_skip_relocation, monterey:       "15a7da8e248a4fe042d62ce9686334e50bcf727db26fd30e32026b9ae0cd2a77"
    sha256 cellar: :any_skip_relocation, big_sur:        "15a7da8e248a4fe042d62ce9686334e50bcf727db26fd30e32026b9ae0cd2a77"
    sha256 cellar: :any_skip_relocation, catalina:       "15a7da8e248a4fe042d62ce9686334e50bcf727db26fd30e32026b9ae0cd2a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba130135bb24951626fddd875839b6d2be1f1b15db0c68d28c47ce525f2a9d55"
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
