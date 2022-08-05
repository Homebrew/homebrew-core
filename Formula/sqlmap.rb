class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.6.8.tar.gz"
  sha256 "35c51f4bd6f5cb8dd8efee4cf87d49bc7e7311ed6f42ffdd038394f7f98e69a2"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f6f07764afd592af9042a89567d6a30179911093d248463eaf62d9815fd39d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74f6f07764afd592af9042a89567d6a30179911093d248463eaf62d9815fd39d"
    sha256 cellar: :any_skip_relocation, monterey:       "83e098ecbff603fdd6c92d405ab4feb7bcb2717deace5a8ea4bfdd75bf4fcc79"
    sha256 cellar: :any_skip_relocation, big_sur:        "83e098ecbff603fdd6c92d405ab4feb7bcb2717deace5a8ea4bfdd75bf4fcc79"
    sha256 cellar: :any_skip_relocation, catalina:       "83e098ecbff603fdd6c92d405ab4feb7bcb2717deace5a8ea4bfdd75bf4fcc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e03f0d01b3cda7c0050dc0b2b20d621346a5c96938e60782b786153a1e263e"
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
