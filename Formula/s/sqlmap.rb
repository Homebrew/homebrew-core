class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.6.tar.gz"
  sha256 "70270ba87461febf7723ccd3e85c4d22efef731e8d9210c2c3ea2b4225453592"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e13ae158709468292e3c430d083fd35dd9d6de6418ee7e777ef2da4d22464aa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e13ae158709468292e3c430d083fd35dd9d6de6418ee7e777ef2da4d22464aa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13ae158709468292e3c430d083fd35dd9d6de6418ee7e777ef2da4d22464aa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0d606d1994f5eb36b8f423f44bf45656ccc77718772c2012ef9c6ef052615bf"
    sha256 cellar: :any_skip_relocation, ventura:        "b0d606d1994f5eb36b8f423f44bf45656ccc77718772c2012ef9c6ef052615bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d606d1994f5eb36b8f423f44bf45656ccc77718772c2012ef9c6ef052615bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5b47985a9ecf22ba1cde6d5a05de2ce35654fbe2eb71550eb2bb1da21779e6"
  end

  depends_on "python@3.12"

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
