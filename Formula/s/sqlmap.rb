class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.2.tar.gz"
  sha256 "6cf2c3fba289898cbfcd88b6f3cc844a63ef5a3952b2dc2132a35171330c1f0a"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4bacc68f37a34f8ac960e62b1420f474f5ab6bf12b0fccf3047004bc82614fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4bacc68f37a34f8ac960e62b1420f474f5ab6bf12b0fccf3047004bc82614fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4bacc68f37a34f8ac960e62b1420f474f5ab6bf12b0fccf3047004bc82614fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "602b70a8dd1c90013c3b24928466f08a8deb28cb4245a29f7a41472000d494ae"
    sha256 cellar: :any_skip_relocation, ventura:        "602b70a8dd1c90013c3b24928466f08a8deb28cb4245a29f7a41472000d494ae"
    sha256 cellar: :any_skip_relocation, monterey:       "602b70a8dd1c90013c3b24928466f08a8deb28cb4245a29f7a41472000d494ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149aa410af349980e39e5683cf8c66aaaa8d16101c944fce297127621c974d40"
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
