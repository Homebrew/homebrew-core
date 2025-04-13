class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.4.tar.gz"
  sha256 "aa7d89591945efe25ea3a41292630606ba9c8196294f920abe752f430a67437a"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4f97b48a8c0f01e8094a6395005a091f802efee8005bce04757b7edf418197"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4f97b48a8c0f01e8094a6395005a091f802efee8005bce04757b7edf418197"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d4f97b48a8c0f01e8094a6395005a091f802efee8005bce04757b7edf418197"
    sha256 cellar: :any_skip_relocation, sonoma:        "53dd22bfcf8c0bf7cfb96e1caf46ebcd5aebf72e76d1c060b44ffe6a1d68e684"
    sha256 cellar: :any_skip_relocation, ventura:       "53dd22bfcf8c0bf7cfb96e1caf46ebcd5aebf72e76d1c060b44ffe6a1d68e684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f40b6e2dde82a71786d1e903ff2c2a5c60b2bbf8dbc86a2ccc9e443665fdc0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f40b6e2dde82a71786d1e903ff2c2a5c60b2bbf8dbc86a2ccc9e443665fdc0f2"
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
