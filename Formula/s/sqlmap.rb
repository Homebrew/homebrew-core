class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.5.tar.gz"
  sha256 "4ce5f6e908fd16ce20aa36b7c3eda66e417ba0b1545e3dda9cb4b836c651a865"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c73164a4b124bc3af513eb3f6ccada62cf0b9d05e916bdf997701740a0f4fd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c73164a4b124bc3af513eb3f6ccada62cf0b9d05e916bdf997701740a0f4fd6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c73164a4b124bc3af513eb3f6ccada62cf0b9d05e916bdf997701740a0f4fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbeeda0b7ecb17eaf1af4bdaad6f2f66693ce8eeebe4fe7464962b07fc676d1"
    sha256 cellar: :any_skip_relocation, ventura:       "7fbeeda0b7ecb17eaf1af4bdaad6f2f66693ce8eeebe4fe7464962b07fc676d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97d27f7a70dbef5771f432b6968ea8f5a9bd0690fae334d46eaa3b53d05e86c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d27f7a70dbef5771f432b6968ea8f5a9bd0690fae334d46eaa3b53d05e86c9"
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
