class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.10.11.tar.gz"
  sha256 "22a8dbd1b18b2249302029a3ed259a92adecc9103cc2fa4908aac0d3743e8ad0"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    rebuild 1
    manifest_sha256 "8e10397d9afa0231725f8f1e3bdee9252873bb8b381c5c4da01d9bec16385422"
    sha256 cellar: :any_skip_relocation, all: "1bebfbf5f08ba60849c40869b4c7d72f1184e5e44f70c9da064def17a547d3ec"
  end

  uses_from_macos "sqlite" => :test
  uses_from_macos "python"

  def install
    libexec.install Dir["*"]

    %w[sqlmap sqlmapapi].each do |cmd|
      rewrite_shebang detected_python_shebang(use_python_from_path: true), libexec/"#{cmd}.py"
      bin.install_symlink libexec/"#{cmd}.py"
      bin.install_symlink bin/"#{cmd}.py" => cmd
    end

    # Build an `:all` bottle
    inreplace libexec/"thirdparty/magic/magic.py", "/usr/local/Cellar", "#{HOMEBREW_PREFIX}/Cellar"
    inreplace libexec/"lib/core/dicts.py", "/usr/local/var/www", "#{HOMEBREW_PREFIX}/var/www"
    inreplace libexec/"lib/core/settings.py", "/opt/homebrew", HOMEBREW_PREFIX
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
