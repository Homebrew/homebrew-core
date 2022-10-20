class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.10.tar.gz"
  sha256 "dc3a15bfac612c765133c1657d9358fda8559ca17e5439ac463121a29a9cb727"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0099b76f7d9c7674fe8e548d37a30a063c94743fe0201cfc5f81017bc8c3eaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0099b76f7d9c7674fe8e548d37a30a063c94743fe0201cfc5f81017bc8c3eaf"
    sha256 cellar: :any_skip_relocation, monterey:       "7ffa44ab3f8f37fa9f09be59593ad9946f1075ad8ac4775ca850003531ac64b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ffa44ab3f8f37fa9f09be59593ad9946f1075ad8ac4775ca850003531ac64b0"
    sha256 cellar: :any_skip_relocation, catalina:       "7ffa44ab3f8f37fa9f09be59593ad9946f1075ad8ac4775ca850003531ac64b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485966126585a97cf9c594625f779433ac7b9faf6c873e2a24841d8a063559e8"
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
