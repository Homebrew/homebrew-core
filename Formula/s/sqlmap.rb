class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.5.tar.gz"
  sha256 "8135305a3e45ce7b29bae02bf77e318091b398703bf727c91ec4d2b375fe79d7"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b75889ccfc9a2d9487d4a81faeedce83087909f0618f5095d7eeccd157406eff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "633b931c1b6ab860119374e0d321c0256661e7c1129d63f3202590992842a243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d51514a34879801f456bd7b268649607984fc5a4ff57119bc0c676658a444ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ecb543370ed3d2fe4bc6c40d203ad08499ba9738b5fb5b28ae50d22ce100632"
    sha256 cellar: :any_skip_relocation, ventura:        "1ec841686034e5b8fa0beaab78456f52940d9a528b57a1e5ee6224762c0eda26"
    sha256 cellar: :any_skip_relocation, monterey:       "9195739fff40ce165da22942667f2a2b27890e0de25c036ed8c14ccb0146cb96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1859e9081fc9f04ee2c3a728497948012829658a349e989efb00a4502ea507d"
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
