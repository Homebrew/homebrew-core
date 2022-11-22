class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/2d/b0/ffe9e812fa710579d07369763262e418cadb2a99fc5d0ec0d685c7f33a69/todoman-4.1.0.tar.gz"
  sha256 "ce3caa481d923e91da9b492b46509810a754e2d3ef857f5d20bc5a8e362b50c8"
  license "ISC"
  revision 1
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc11977db8556b8020aa4d6a3c7191edd4c109371128c308f692d85523631c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3af01329308dd8810449d967d022f2484bf56d342e42f44e8aa7b06cf086ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98016df0d18a908c967133abae1a68baf130c035be4918cbbf08b1bab0056905"
    sha256 cellar: :any_skip_relocation, ventura:        "f5cff41e9eefd51bbfdeb4de363209509ab9c7cceff30408522f4ca0ec5dd522"
    sha256 cellar: :any_skip_relocation, monterey:       "923854a7c40ad012b95d7da8148bcb010a1dcb9cc26ece944e324d26cc43b27c"
    sha256 cellar: :any_skip_relocation, big_sur:        "590e1eefc3398921e37e4243aa4a8f6a599227482709fcff26da4dfc61d5aff4"
    sha256 cellar: :any_skip_relocation, catalina:       "8fa7ef05501e43aefaee1d0419886b432927ffb2a879d411cfbe1ca9c3d499ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b939b9afc6ca8dc3d4289a3d962da1d975ff3eabbea76368f56ef3a08b55788"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "devtodo", because: "both install a `todo` binary"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/51/19/3e1adf0e7a8c8361496b085edcab2ddcd85410735a2b6fdd044247fc5b75/humanize-4.4.0.tar.gz"
    sha256 "efb2584565cc86b7ea87a977a15066de34cdedaf341b11c851cfcfd2b964779c"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/8b/e2/17bae067d82e71ba56f09346cb76aa84ca0bbbee2df54eaa102f93f733bf/icalendar-5.0.2.tar.gz"
    sha256 "edc635fd9334102d409f4571fb953ef0f84ce01dd15ff83cac6afafe89c8e56a"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "contrib/completion/bash/_todo" => "todo"
    zsh_completion.install "contrib/completion/zsh/_todo"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/".config/todoman/config.py").write <<~EOS
      path = "#{testpath}/.calendar/*"
      date_format = "%Y-%m-%d"
      default_list = "Personal"
    EOS
    (testpath/".calendar/Personal").mkpath
    system "#{bin}/todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end
