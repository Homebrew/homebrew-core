class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/ee/7a/4c69c6a1054b319421d5acf028564bb1303ea9da42032a2000021d6495ee/west-1.2.0.tar.gz"
  sha256 "b41e51ac90393944f9c01f7be27000d4b329615b7ed074fb0ef693b464681297"
  license "Apache-2.0"
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f63eace11bf4fef4af315a2dd52171c619998b1e72a2e7156475b3c0905260c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22de056381f80c02d0a622f4f94a6b8a10d270bf3a4975de610f4567cf715a71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "427397d11836070094ae1a3df9526ed61f8d173a8d2576cc0409a2d0e21413a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef07c104737f4e71cf49730b6b6e28b294c86340110ad7c31e5dbff333ebb702"
    sha256 cellar: :any_skip_relocation, ventura:        "793410c0f46f336bf98898bff4eaedf42ed764f2b068b240f146dba5826dc934"
    sha256 cellar: :any_skip_relocation, monterey:       "1954a859779988a69af6ba7d915983466a0791296d6d02323426446c31d9479b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc0e03da32954056f08d5a83899324aab48fa43a5bd3acb9f10fd4818178e0f8"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"
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

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/de/7d/4f70a93fb0bdc3fb2e1cbd859702d70021ab6962b7d07bd854ac3313cb54/ruamel.yaml-0.17.35.tar.gz"
    sha256 "801046a9caacb1b43acc118969b49b96b65e8847f29029563b29ac61d02db61b"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
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
