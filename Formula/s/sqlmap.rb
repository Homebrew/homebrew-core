class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/refs/tags/1.8.3.tar.gz"
  sha256 "b6bf5c00ecb96fbbc673ac9a5453886140640f28cdcbd6091d55afd63c4da617"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64bc31d3f648ab793340848ddee9abc5e4aa6490a270c7a30eaf11096ade5ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64bc31d3f648ab793340848ddee9abc5e4aa6490a270c7a30eaf11096ade5ad2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64bc31d3f648ab793340848ddee9abc5e4aa6490a270c7a30eaf11096ade5ad2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c8cd236762564bfefe94d129aa484f986ccd6e31b80a46f0b893d762221a1ad"
    sha256 cellar: :any_skip_relocation, ventura:        "5c8cd236762564bfefe94d129aa484f986ccd6e31b80a46f0b893d762221a1ad"
    sha256 cellar: :any_skip_relocation, monterey:       "5c8cd236762564bfefe94d129aa484f986ccd6e31b80a46f0b893d762221a1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56a4a536d7b093e097ba8cba4c948d59c6ed4ea9b65dc60dce349a130a75b929"
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
