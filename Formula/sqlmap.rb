class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.5.tar.gz"
  sha256 "534194953d8a95ff1d28d1a19f9b2c1b6d021fe9bc3ea7368ecab2084ceba714"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8563f0bf5041f1951f26d374134b46296b6869a4d3f5ad8ef0a665a961e2920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8563f0bf5041f1951f26d374134b46296b6869a4d3f5ad8ef0a665a961e2920"
    sha256 cellar: :any_skip_relocation, monterey:       "5acd44a65abdc23c7ff87d2662b6e1dc2a21e27e946dbf0d77b081d1442a895d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5acd44a65abdc23c7ff87d2662b6e1dc2a21e27e946dbf0d77b081d1442a895d"
    sha256 cellar: :any_skip_relocation, catalina:       "5acd44a65abdc23c7ff87d2662b6e1dc2a21e27e946dbf0d77b081d1442a895d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4581d44a294b3a3213d840f5b8b267c594a6b76e3fa692b71f009f435c0f64fd"
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
