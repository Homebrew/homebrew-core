class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.9.tar.gz"
  sha256 "7954fb45930ad5a0fb49834d42d3c895dbf9723784c439ee1d47a12615a5307c"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ffb9e084517b8170bf1b8f3a8c846f7b30f7b33968d238c0c9d2432da51c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70ffb9e084517b8170bf1b8f3a8c846f7b30f7b33968d238c0c9d2432da51c89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70ffb9e084517b8170bf1b8f3a8c846f7b30f7b33968d238c0c9d2432da51c89"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4c1840ec94c4887fb1f75c742769dd4df3d34944c68117601c123809ea6ffd"
    sha256 cellar: :any_skip_relocation, ventura:       "ed4c1840ec94c4887fb1f75c742769dd4df3d34944c68117601c123809ea6ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfed37e19af330c4fab2b5feb4f8b31183bee140c457963974314f2547a922e1"
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
