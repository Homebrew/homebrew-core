class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/ae/9c/16f4df520be759b8de1b35d6959fabb86ec81b44ba0300ec68d5d869f006/west-0.14.0.tar.gz"
  sha256 "9a52a78565fd4d69c64b75c549f61b131892b1b6d26c1cc162cdead1a3cf4b8f"
  license "Apache-2.0"
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfd642c688a6faf1e631076913634527aeec5ba2a491cbfbe04f416a863a3dd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b24b137ec120b1309da110333531ecd95c563db9033ce3244619f933facfa8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5a6cba418e165f66aeebd6c9a0320aac87f97edd800ef0a6342f9d41c4cf9ea"
    sha256 cellar: :any_skip_relocation, ventura:        "c075c2cfa7ebed2005a9f00cf870a9344f6951d70c31cc9d0e731a88b05c24e0"
    sha256 cellar: :any_skip_relocation, monterey:       "c6d775b67b23fae50928f859f67a9224b1c665e93cad3edc92559bc206e78e09"
    sha256 cellar: :any_skip_relocation, big_sur:        "f91d9ee4e59bdf503b98c14faca5102aff2bf75a94031b58faf4ef3b45eb0e70"
    sha256 cellar: :any_skip_relocation, catalina:       "284d97fb4bfe590b937404ab2b5d6915e211f7fb9a1e15791b2d88158e3ce158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbcbd3f97e2da46276cb1be5df0b99c6b0bfdcc93e89783965842866208964a3"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/"west" do
      mkdir "test-project"
      (testpath/"west/test-project/west.yml").write <<~EOS
        manifest:
          self:
            path: test-project
      EOS
      system bin/"west", "init", "-l", testpath/"west/test-project"
      assert_predicate testpath/"west/.west", :exist?
    end
  end
end
