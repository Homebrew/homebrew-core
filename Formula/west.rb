class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/0a/4a/ffdeea989c54f855ca5e7e41d4dcf30108ff0d329de6271f6d2b38389b3f/west-0.13.0.tar.gz"
  sha256 "8e53a678833a35f818ca48e182cecaa6701714c6d3fe5a5b4ff6c1689d82198e"
  license "Apache-2.0"
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92edeaaf93f93ab915818b7031a6d73b0a03e479f241c6420810bf538903d5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94f5a876f7bb80c23b52887c96cabb094dd4151d17d300e568ad4f8462f1fffe"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0cda64ce7f392d2b0eb62e4cb4695ecd9cc88c53c42ce8cafac82812f93623"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e0bcb90f2b7d8011b0f4c26bb157cc2f62327143bfdf6143629edbba7494fa1"
    sha256 cellar: :any_skip_relocation, catalina:       "4e37e140fcf33639785889864db5277cd8744e9934b176f366e47ff9e08ff660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bf6a5d9942fbcd051c99c767a35aae0c9a1b685d21d8ed22d4872c944fe06d"
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
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
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
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
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
