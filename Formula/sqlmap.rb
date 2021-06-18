class Sqlmap < Formula
  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.5.6.tar.gz"
  sha256 "adc5feaf873ca6f50d4a1f3cf9d047b20c4e12733355528acb467926c6c375f1"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b2c9fed5611150a0e2f8767ddcb7f7f11482da54beb04d9f3d672acaa0a89040"
    sha256 cellar: :any_skip_relocation, big_sur:       "a463242243dabbce67c7f5c134da0c9ec62acd8a22188a28ff2a12895de8a36a"
    sha256 cellar: :any_skip_relocation, catalina:      "a463242243dabbce67c7f5c134da0c9ec62acd8a22188a28ff2a12895de8a36a"
    sha256 cellar: :any_skip_relocation, mojave:        "a463242243dabbce67c7f5c134da0c9ec62acd8a22188a28ff2a12895de8a36a"
  end

  def install
    libexec.install Dir["*"]

    files = [
      libexec/"lib/core/dicts.py",
      libexec/"lib/core/settings.py",
      libexec/"lib/request/basic.py",
      libexec/"thirdparty/magic/magic.py",
    ]
    inreplace files, "/usr/local", HOMEBREW_PREFIX

    bin.install_symlink libexec/"sqlmap.py"
    bin.install_symlink bin/"sqlmap.py" => "sqlmap"

    bin.install_symlink libexec/"sqlmapapi.py"
    bin.install_symlink bin/"sqlmapapi.py" => "sqlmapapi"
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
