class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.tar.gz"
  sha256 "aa00e08007bfdb06a362a0c2798073af8e7053a97ead8ed7cca86393a94ec2e1"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4700564a062b13cdb54ff7dcb3073de2e97181fe3370f5ad48ca9a4ca8a91a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4700564a062b13cdb54ff7dcb3073de2e97181fe3370f5ad48ca9a4ca8a91a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4700564a062b13cdb54ff7dcb3073de2e97181fe3370f5ad48ca9a4ca8a91a9"
    sha256 cellar: :any_skip_relocation, ventura:        "7d52433d0a3ff9ea5a0fde23799aac67d54bff616a7b981155b0a3d7022b5550"
    sha256 cellar: :any_skip_relocation, monterey:       "7d52433d0a3ff9ea5a0fde23799aac67d54bff616a7b981155b0a3d7022b5550"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d52433d0a3ff9ea5a0fde23799aac67d54bff616a7b981155b0a3d7022b5550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52352a4ce1819d0b244f121ee6ae4097d10982493bf433d5ea2e5026b6727b31"
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
