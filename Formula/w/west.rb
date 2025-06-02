class West < Formula
  include Language::Python::Virtualenv

  desc "Zephyr meta-tool"
  homepage "https://github.com/zephyrproject-rtos/west"
  url "https://files.pythonhosted.org/packages/ac/d0/4fc4d6ded3cca8736a982a33a39d2fad7a6170624323e8f7afdabd27e329/west-1.4.0.tar.gz"
  sha256 "908a07ae7cc334a88cb2f069b430484dfdfdda0c3422d14b9e23a43030cf9cc6"
  license "Apache-2.0"
  head "https://github.com/zephyrproject-rtos/west.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4eca7a6dd5aba30489c779ce193b625af5589963aefac6ae2f70eb5d68b14f5d"
    sha256 cellar: :any,                 arm64_sonoma:  "78f9966dae45009e25a768dd6ccc50d3b13b7d73e5a020d2bc089b45951d00b0"
    sha256 cellar: :any,                 arm64_ventura: "52319ab39f339b853cafe20dcb2c113cc43eb7db9fe2c037ae155da63df2cb85"
    sha256 cellar: :any,                 sonoma:        "bde26447dfd9f5b7eab37c1ff049ff0308b3c7660e5a833801a1567d626f751a"
    sha256 cellar: :any,                 ventura:       "a9528485221186f80f5b426dfdfc8d08d59cc2919aa06513d23b7fe25ca9e217"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "621834b79cdbde505e5ae0297a3b81e6e8e26b00ac7a9654767906973e56105e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c6b0472c35c5245c3b91814008fa38c545b6b7ce20ebce1bc0ce57b4128c11"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pykwalify" do
    url "https://files.pythonhosted.org/packages/d5/77/2d6849510dbfce5f74f1f69768763630ad0385ad7bb0a4f39b55de3920c7/pykwalify-1.8.0.tar.gz"
    sha256 "796b2ad3ed4cb99b88308b533fb2f559c30fa6efb4fa9fda11347f483d245884"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/ea/46/f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5/ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/"west" do
      mkdir "test-project"
      (testpath/"west/test-project/west.yml").write <<~YAML
        manifest:
          self:
            path: test-project
      YAML
      system bin/"west", "init", "-l", testpath/"west/test-project"
      assert_path_exists testpath/"west/.west"
    end
  end
end
