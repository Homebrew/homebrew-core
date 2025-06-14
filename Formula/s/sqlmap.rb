class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.6.tar.gz"
  sha256 "7cf60ca5364062ef7eab05a26fdeaf3b1457ea2200bf8198ed131ef7931c9bbf"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee934d9313ff7f89ab02de21440813191410b82481bb1a475a793886d5eec88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee934d9313ff7f89ab02de21440813191410b82481bb1a475a793886d5eec88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cee934d9313ff7f89ab02de21440813191410b82481bb1a475a793886d5eec88"
    sha256 cellar: :any_skip_relocation, sonoma:        "2592bc251fcba9bd2d2c687505c576026674de20e25fce11c31ea2957c40099a"
    sha256 cellar: :any_skip_relocation, ventura:       "2592bc251fcba9bd2d2c687505c576026674de20e25fce11c31ea2957c40099a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6793002486426a840abbe5d9d068cbf4fb51e7cdae68d3e29fdfb402df1952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6793002486426a840abbe5d9d068cbf4fb51e7cdae68d3e29fdfb402df1952"
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
