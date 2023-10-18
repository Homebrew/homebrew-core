class Todoman < Formula
  include Language::Python::Virtualenv

  desc "Simple CalDAV-based todo manager"
  homepage "https://todoman.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/98/3d/db9427c5612c2ba2313b7782ee1f1e28a9c4995d54727d7e9ea23ab131ae/todoman-4.3.2.tar.gz"
  sha256 "370aae24d2e7ff1ab377c26e38d13556aab917db83f9527c72abac9636fae628"
  license "ISC"
  head "https://github.com/pimutils/todoman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "489a60940cc2eb94ed690f21beb98bc23c4c49c8da4751da396b515907f977bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c3a28c1737f97608ab10632f2d7dc33ce76f5600433e3a1f40a9f62fb0cdb07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b308ec5459aedad9ab4338eb443f0f2830e7e1143a447b529023e4711500b62"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a2ec74dafa6325c7869fbc363d77ecac36611bc2321e78149b7ed031d0a097b"
    sha256 cellar: :any_skip_relocation, ventura:        "162189d20a401879a545d6b37ae6e6b92b4108be6ec652b3b438f9e6ea3dfffa"
    sha256 cellar: :any_skip_relocation, monterey:       "c5aad3bd1a7314f59b9941dbabe94832b7413cabf93e76c6a498ecca78eabda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1588ad4e900b894a0dc3b5d2bd4da5cd68c8b474aa5efad3401157789dad6f8"
  end

  depends_on "jq" # Needed for ZSH completions.
  depends_on "python-pytz"
  depends_on "python@3.12"
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
    url "https://files.pythonhosted.org/packages/40/d7/06707c968c2ce93e60eeb9f849c84e96c710660054e09791ffa3e5ef04ad/icalendar-5.0.10.tar.gz"
    sha256 "34f0ca020b804758ddf316eb70d1d46f769bce64638d5a080cb65dd46cfee642"
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
    url "https://files.pythonhosted.org/packages/5f/cf/2f01d2231e7fb52bd8190954b6165c89baa17e713c690bdb2dfea1dcd25d/urwid-2.2.2.tar.gz"
    sha256 "5f83b241c1cbf3ec6c4b8c6b908127e0c9ad7481c5d3145639524157fc4e1744"
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
