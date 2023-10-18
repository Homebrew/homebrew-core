class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.10.tar.gz"
  sha256 "75a9fb2c8e64292baf1380d75ce4024eed7a9763375748042015bc401e784c78"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "950b1561f2f937d621e6d048f8d7979131004f735bdfa1b92b4024cd521bc08d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950b1561f2f937d621e6d048f8d7979131004f735bdfa1b92b4024cd521bc08d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950b1561f2f937d621e6d048f8d7979131004f735bdfa1b92b4024cd521bc08d"
    sha256 cellar: :any_skip_relocation, sonoma:         "77829c525e30975222af5b2f4a329b616c264af44dac7d1017252f63066c02a8"
    sha256 cellar: :any_skip_relocation, ventura:        "77829c525e30975222af5b2f4a329b616c264af44dac7d1017252f63066c02a8"
    sha256 cellar: :any_skip_relocation, monterey:       "77829c525e30975222af5b2f4a329b616c264af44dac7d1017252f63066c02a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3998eac4bdeab7a19844f5e3ffdcbcf40b2e25f5903d085e6683d92df518789"
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
