class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/fd/60/dbd18038cfe5a795d2e427b3ae4112c340966ed2d3a70303a4d59d7313eb/todoman-4.4.0.tar.gz"
  sha256 "0b7beeb8c73bfa299147288d9b657bc4e0e288febb84e198ef72cb1412af9db6"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bf6c5dec96c8fb238cd1b972c3d352be548e8e2610dec4943d34426b5382b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "330cbadb3883c67fb1dab96fba318dc5f3a2d32b1fe492a460a9bac35d7bf190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6185c3a7242abe09eab8d78c23585fae98957132cb702e278f9fd8f47e22e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d63bd7534dd9d4131d527a6949551c88cf50ebc575f06ba697a17f61aebc5cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "e35a9e9ff8638c1cea70cb9994bee9afd203a59582b874703f6c58251393312d"
    sha256 cellar: :any_skip_relocation, monterey:       "67ec73375b040a8d836b74b8eca7072ccab5b8450404d6d3a9b4c87429ead964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f31099a4e89da4db04bc0c253b485de92a6ccf1b0c1edc025d3118cf4b07f287"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python@3.12"

  conflicts_with "bash-snippets", because: "both install `todo` binaries"
  conflicts_with "devtodo", because: "both install a `todo` binary"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/32/32/228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260/click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/6c/23/187a28257fe26848d07af225cef86abe3712561bd8af93cbd3a64d6eb6ea/icalendar-5.0.11.tar.gz"
    sha256 "7a298bb864526589d0de81f4b736eeb6ff9e539fefb405f7977aa5c1e201ca00"
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
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/93/6c/f40b1ffc0f1b81a51ebc66615d1177a590ac23d6e300921a047a20f5dbd4/urwid-2.6.4.tar.gz"
    sha256 "bc302170fdbdda0aded2787ba66006af939dcff967606e9840a6f2af149adf12"
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

    (testpath/".config/todoman/config.py").write <<~EOS
      path = "#{testpath}/.calendar/*"
      date_format = "%Y-%m-%d"
      default_list = "Personal"
    EOS

    (testpath/".calendar/Personal").mkpath
    system bin/"todo", "new", "newtodo"
    assert_match "newtodo", shell_output("#{bin}/todo list")
  end
end
