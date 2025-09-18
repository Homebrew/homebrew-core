class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/87/4c/1369f1a4b0c6eefcca49db997aa8ae0cd53d64e03d7c0f80905b6380a444/todoman-4.6.0.tar.gz"
  sha256 "bff9be48c88168c3f7b732bb0b65f3539abbcd3383e878f9835fcf43c83add53"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "024bea37eed187445192eef3f0bc4aab84e9815e9a97605d1f62047936fa37f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637f9ef1c34fe16d767c6df4dffe91f852263ef90d47e60df8eedbc829dd4faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637f9ef1c34fe16d767c6df4dffe91f852263ef90d47e60df8eedbc829dd4faf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "637f9ef1c34fe16d767c6df4dffe91f852263ef90d47e60df8eedbc829dd4faf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa6899415c077a827ec757361510d984578bbfdbbed45407251a810d841494c"
    sha256 cellar: :any_skip_relocation, ventura:       "8aa6899415c077a827ec757361510d984578bbfdbbed45407251a810d841494c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637f9ef1c34fe16d767c6df4dffe91f852263ef90d47e60df8eedbc829dd4faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "637f9ef1c34fe16d767c6df4dffe91f852263ef90d47e60df8eedbc829dd4faf"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python@3.13"

  conflicts_with "bash-snippets", because: "both install `todo` binaries"

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/22/d1/bbc4d251187a43f69844f7fd8941426549bbe4723e8ff0a7441796b0789f/humanize-4.12.3.tar.gz"
    sha256 "8430be3a615106fdfceb0b2c1b41c4c98c6b0fc5cc59663a5539b111dd325fb0"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/08/13/e5899c916dcf1343ea65823eb7278d3e1a1d679f383f6409380594b5f322/icalendar-6.3.1.tar.gz"
    sha256 "a697ce7b678072941e519f2745704fc29d78ef92a2dc53d9108ba6a04aeba466"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/46/2d/71550379ed6b34968e14f73b0cf8574dee160acb6b820a066ab238ef2d4f/urwid-3.0.2.tar.gz"
    sha256 "e7cb70ba1e7ff45779a5a57e43c57581ee7de6ceefb56c432491a4a6ce81eb78"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/completion/bash/_todo" => "todo"
    zsh_completion.install "contrib/completion/zsh/_todo"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    (testpath/".config/todoman/config.py").write <<~PYTHON
      path = "#{testpath}/.calendar/*"
      date_format = "%Y-%m-%d"
      default_list = "Personal"
    PYTHON

    (testpath/".calendar/Personal").mkpath
    system bin/"todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end
