class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.8.tar.gz"
  sha256 "3bab3fbe9903b5c335202a7bcfc52bfd05c66634dd9f19b8d5bfaefcc98c1fdf"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68512a9d3da07a5b4f602035bb0877ec716063c5af7d7ac27cecf9e1f5d94357"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68512a9d3da07a5b4f602035bb0877ec716063c5af7d7ac27cecf9e1f5d94357"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68512a9d3da07a5b4f602035bb0877ec716063c5af7d7ac27cecf9e1f5d94357"
    sha256 cellar: :any_skip_relocation, sonoma:         "12532c934465593fd780c0231473f62f40daa9544c722a57345673c70ed743c2"
    sha256 cellar: :any_skip_relocation, ventura:        "12532c934465593fd780c0231473f62f40daa9544c722a57345673c70ed743c2"
    sha256 cellar: :any_skip_relocation, monterey:       "12532c934465593fd780c0231473f62f40daa9544c722a57345673c70ed743c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0966de87ddd92949f163c4ace349d7c2bc1275dbda7fe3b0fafe6cd50c4dd5b"
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
