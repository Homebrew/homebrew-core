class Sqlmap < Formula
  include Language::Python::Shebang

  desc "Penetration testing for SQL injection and database servers"
  homepage "https://sqlmap.org"
  url "https://github.com/sqlmapproject/sqlmap/archive/1.7.4.tar.gz"
  sha256 "ad09a2e58d489762055f289a2e39c5f94e1ec80973cf7be488c4582bc43ae8e6"
  license "GPL-2.0-or-later"
  head "https://github.com/sqlmapproject/sqlmap.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2be08e8d1cb30af57700d7da098f5f35fb2d3dd4fbaec18f132dec0b7d3af168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be08e8d1cb30af57700d7da098f5f35fb2d3dd4fbaec18f132dec0b7d3af168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2be08e8d1cb30af57700d7da098f5f35fb2d3dd4fbaec18f132dec0b7d3af168"
    sha256 cellar: :any_skip_relocation, ventura:        "ed05d756bbcf8285e81af22345ceaf7d6a97e051f654e55c081ad59af14407b4"
    sha256 cellar: :any_skip_relocation, monterey:       "ed05d756bbcf8285e81af22345ceaf7d6a97e051f654e55c081ad59af14407b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed05d756bbcf8285e81af22345ceaf7d6a97e051f654e55c081ad59af14407b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1293115565c33a0b70f1fb8650633d007e9f8c001ad459bfee35b81f08016e3"
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
