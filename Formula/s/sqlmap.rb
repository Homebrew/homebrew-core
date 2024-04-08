class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.4.tar.gz"
  sha256 "6871a869dc3e785a4a20679b040a91628d851b4a019857303277c743d12d0914"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "761f7e47d68ff257050f455d4e7110cdd3827c68e8cf04bfb5e4576cdc2c72be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761f7e47d68ff257050f455d4e7110cdd3827c68e8cf04bfb5e4576cdc2c72be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "761f7e47d68ff257050f455d4e7110cdd3827c68e8cf04bfb5e4576cdc2c72be"
    sha256 cellar: :any_skip_relocation, sonoma:         "b13faaba6e1665b893608391bdfa2adaa4d7be43565a7b5f37a57b64506330a0"
    sha256 cellar: :any_skip_relocation, ventura:        "b13faaba6e1665b893608391bdfa2adaa4d7be43565a7b5f37a57b64506330a0"
    sha256 cellar: :any_skip_relocation, monterey:       "b13faaba6e1665b893608391bdfa2adaa4d7be43565a7b5f37a57b64506330a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089956126e540badb12d1562ac12749b626b96b1a4dba56fcc9a15dc2c082996"
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
