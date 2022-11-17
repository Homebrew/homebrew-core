class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.11.tar.gz"
  sha256 "7c10a92591f440678af7eaf07c439a331c79a86e44588e32cbce490ab731bafe"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5870be0d75ed6ae5f975846fd423bb821421297bade85459a2814aee910a460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5870be0d75ed6ae5f975846fd423bb821421297bade85459a2814aee910a460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5870be0d75ed6ae5f975846fd423bb821421297bade85459a2814aee910a460"
    sha256 cellar: :any_skip_relocation, ventura:        "b916a5a057c935bc2cafd4b2d8f3f09939cde30c9d03cb66fe682fa7d9b1c44f"
    sha256 cellar: :any_skip_relocation, monterey:       "b916a5a057c935bc2cafd4b2d8f3f09939cde30c9d03cb66fe682fa7d9b1c44f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b916a5a057c935bc2cafd4b2d8f3f09939cde30c9d03cb66fe682fa7d9b1c44f"
    sha256 cellar: :any_skip_relocation, catalina:       "b916a5a057c935bc2cafd4b2d8f3f09939cde30c9d03cb66fe682fa7d9b1c44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b7b16cafabb429e0aa1847b9b0db9491a8a57687955ccc81ceedb9ee81e8d45"
  end

  depends_on "python@3.11"

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
