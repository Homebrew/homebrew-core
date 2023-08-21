class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.8.tar.gz"
  sha256 "e67635f16a731f5b941317c9fa771b2a0e988ceefa4bf70b75688bbe1d4488fa"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc9ddf1fbc7a2b839e3b9fb5872903e8f88f797a190d161a9c93ce739115961"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cc9ddf1fbc7a2b839e3b9fb5872903e8f88f797a190d161a9c93ce739115961"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cc9ddf1fbc7a2b839e3b9fb5872903e8f88f797a190d161a9c93ce739115961"
    sha256 cellar: :any_skip_relocation, ventura:        "575e6c803b2815bde74647c52ad415069b02f066bd87cbd70e624f3538de2c33"
    sha256 cellar: :any_skip_relocation, monterey:       "575e6c803b2815bde74647c52ad415069b02f066bd87cbd70e624f3538de2c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "575e6c803b2815bde74647c52ad415069b02f066bd87cbd70e624f3538de2c33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d034a76708dd1d917f99396b26fee977088e0e455b52bc9d79dd9df2e2fa59c"
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
