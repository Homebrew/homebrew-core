class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.wiki/en/latest/"
  url "https://files.pythonhosted.org/packages/9f/1f/3acba68301b0081cec87b1769ba4c3a4a0a30f20879a05420673c7e4671d/tox-4.60.0.tar.gz"
  sha256 "6f93bb580d35e00fc69cfec1116eecbe21155f747753ca5019374f7c69b2eac9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53b3780d690944d8566abde90c370138eccd268880fc6955296349e3c51ec214"
  end

  depends_on "python@3.14"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/70/d2/47e8bc06fe2a06d3f5bdf20f1126ab66c4e99dc48d940e7ba873f7ac7131/cachetools-7.1.7.tar.gz"
    sha256 "a3e2a00b14d8f8a6b70c1dae7b4685e7ad3bc965c5b42124a2d6ce895da6cf50"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/64/a02e6765de08964ed371eca577870593245afc9dfac16d037de7c10d18e6/filelock-3.32.3.tar.gz"
    sha256 "0ffa185a3540854c95caa7fa76b76cb219d907415e2c5dc9af25fd970563487f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b8/d7/e7bfbc86e9f99ff7807e24de7703f032e9c9ba80bb355cf26e0e9bc5a75e/platformdirs-4.11.3.tar.gz"
    sha256 "66a73d38a849810252df809a3d8bcbda8e26f6c189920e7535ad608a48dbb5ab"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/ab/bd/2f985c12bf33fdd8637e3a8f9418d6806f177601dee7c4924d0b2bb28650/pyproject_api-1.11.0.tar.gz"
    sha256 "b8807d85a293e6c9f133e6575946fed45f1d42b22d58c780b33aa2421a799549"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/38/b7/ac44da2cf0e53ada0e419033c2d058219c95dc1403126f163304c9e814b1/python_discovery-1.5.2.tar.gz"
    sha256 "45fd4f20a4e3f9b7bf2e0817870bc8e3b320a19658da177af800768c82dbf354"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/2d/dc/a6eb1ddfa7f1e390fa599b078453c97edb3f6f846b34fb4eac3e8ea16401/virtualenv-21.7.4.tar.gz"
    sha256 "c9d960c95fa458171e58222a5ccab7465298e4b6559977865e627c4719f1e825"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    pyver = Language::Python.major_minor_version(formula_opt_bin("python@3.14")/"python3.14").to_s.delete(".")

    system bin/"tox", "quickstart", "src"
    (testpath/"src/test_trivial.py").write <<~PYTHON
      def test_trivial():
          assert True
    PYTHON
    chdir "src" do
      system bin/"tox", "run"
    end
    assert_path_exists testpath/"src/.tox/py#{pyver}"
  end
end
