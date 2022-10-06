class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.10.tar.gz"
  sha256 "dc3a15bfac612c765133c1657d9358fda8559ca17e5439ac463121a29a9cb727"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14970a52dc83a021f235428e77d939b6b59b009c38a4191fa0c10a8c89bf3f9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14970a52dc83a021f235428e77d939b6b59b009c38a4191fa0c10a8c89bf3f9d"
    sha256 cellar: :any_skip_relocation, monterey:       "217f12ba6edd1b6cbc0c2b6c0388d647e0e2f1389d8021f55491ac8824d131ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "217f12ba6edd1b6cbc0c2b6c0388d647e0e2f1389d8021f55491ac8824d131ef"
    sha256 cellar: :any_skip_relocation, catalina:       "217f12ba6edd1b6cbc0c2b6c0388d647e0e2f1389d8021f55491ac8824d131ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09951a8fb845f4fe65f5e0ec34be64c0f39c51a2ea65d152ca267be769a0baa6"
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
