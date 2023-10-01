class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/98/3d/db9427c5612c2ba2313b7782ee1f1e28a9c4995d54727d7e9ea23ab131ae/todoman-4.3.2.tar.gz"
  sha256 "370aae24d2e7ff1ab377c26e38d13556aab917db83f9527c72abac9636fae628"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86b961abfd2932466d05b570bc1ac2109139425d3913a2543d950f89ded8339e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeef37c08213393f090663bf4636a23caf98ef876f93d4829e364138f62b41cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "182224eccaf1d7247af9ad47346e9f62a14ada31b278ea31317b8bc8e25fb580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4792c6c4ad0cac00a2f4b53c5fce8a31b9df75396010e3d890492a3d6e642e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe0dfb2d10800489b5982b83957a8a3d695209edddfdc77391096a136a59b8b0"
    sha256 cellar: :any_skip_relocation, ventura:        "85f30f84a61cc4aa6c4945bc36a6be35fbcf201521c9c96a59a61674099e4df9"
    sha256 cellar: :any_skip_relocation, monterey:       "268fb8a0aad8323a9ed5bdd7d63b786305675ab8688c9594e1cc15727de48ea0"
    sha256 cellar: :any_skip_relocation, big_sur:        "44f0378b4008370549c045694ccbfd477ec714d3acfe28adfa9847e5b2b19703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2bfd8d592fd663e3f8e7acc0731ae1926d6a3f4657041fb01b370850b11fd4"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python-pytz"
  depends_on "python@3.11"
  depends_on "six"

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
    url "https://files.pythonhosted.org/packages/0c/84/e58c665f4ebb03d2fbeb28b51afb0743f846db18a5b594ed8b8973676ddf/humanize-4.8.0.tar.gz"
    sha256 "9783373bf1eec713a770ecaa7c2d7a7902c98398009dfa3d8a2df91eec9311e8"
  end

  resource "icalendar" do
    url "https://files.pythonhosted.org/packages/7b/cb/ab742b444f6a25a349f061f1d661060060191e065f0aa815ba1bf989bf5c/icalendar-5.0.7.tar.gz"
    sha256 "e306014a64dc4dcf638da0acb2487ee4ada57b871b03a62ed7b513dfc135655c"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
