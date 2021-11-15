class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/75/c4/6541e83caa8ca45259903accb9b90440ea3cd684f60133fab2fbaf33fcce/west-0.12.0.tar.gz"
  sha256 "d7ce0d719fd218fee5983442fe93a33a21a6be6a736915a7ffbe75369714e9ce"
  license "Apache-2.0"
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee52253e476569f70e3e5919338034def7cf9ce50a3b59444f053757a9182849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e679706797ac30173c5631640832b1a66917ec3d6068395dd49891f2f143a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "3fa219cc3b922e7f3eac0036aeec4c7f77c764654496831cd64185a3f5e82eb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "901ebeb78290ac31661898e94d202f13365cd43ad9fb2f54fb3fe6de9920f8ea"
    sha256 cellar: :any_skip_relocation, catalina:       "872cfd4f01e18a1d4523baa94e0f8fdfba65f4d00dcaeee6f2eafed8660bd62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ae8806892760c0f14cc897513b130fe66989c98b947eeb71c2496921999ee5"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/4d/34/523195b783e799fd401ad4bbc40d787926dd4c61838441df08bf42297792/packaging-21.2.tar.gz"
    sha256 "096d689d78ca690e4cd8a89568ba06d07ca097e3306a4381635073ca91479966"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/4d/15/7fc04de02ca774342800c9adf1a8239703977c49c5deaadec1689ec85506/ruamel.yaml-0.17.17.tar.gz"
    sha256 "9751de4cbb57d4bfbf8fc394e125ed4a2f170fbff3dc3d78abf50be85924f8be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
