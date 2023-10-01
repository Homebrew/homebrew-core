class Sqlfluff < Formula
  include Language::Python::Virtualenv

  desc "SQL linter and auto-formatter for Humans"
  homepage "https://docs.sqlfluff.com/"
  url "https://files.pythonhosted.org/packages/33/f8/c42fc747dd37b95c50408d1ba9c62aab09c3cc30ba4542cf9be25378ec7c/sqlfluff-2.3.2.tar.gz"
  sha256 "3403ce7e9133766d7336b7e26638657ec6cc9e5610e35186b7f02cc427dd49b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd7daff63c98b63a119fcc08f1b1a67e6a700205618210517a9d47aa53f75f31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c46f9acce58e85d9a81982b9d888a6f7b7dccb3980b377d73f328c19067d93e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6b4b9238e9830ff00b280aa24da76601cc7feffabee21a931859e79bf99488"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfa72bda561be77367de5c5e543be07076e6302786c48dc981b30aa888a4e35d"
    sha256 cellar: :any_skip_relocation, sonoma:         "65d3cde537ab74329316a56b6d6f926254b288b4a144ed8783b988faaa47a8e3"
    sha256 cellar: :any_skip_relocation, ventura:        "aa0764cea3b4a71ab8f29b6bf0e155c34173ec2cc2319447faf99dabad2f5b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "596e286a60ad60a5e9dbefb42a40b47c3c3a140dcd243d201bacf6df528f0f84"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5441649b00f52d0c8e88b94b47d7eb2fdaf5eabef6a4a85f9ebafec437d4ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79ae88e51751f47f8a7492a6f8a02a1a2e2a524bcad83aea7431c386b3d4905"
  end

  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diff-cover" do
    url "https://files.pythonhosted.org/packages/37/c2/f1919023fea5079b479d97793c368db8dd337170a7dbc4b5e76c1fc29d12/diff_cover-7.7.0.tar.gz"
    sha256 "60614cf7e722cf7fb1bde497afac0b514294e1e26534449622dac4da296123fb"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e5/d0/18209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7/pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/4f/1d/6998ba539616a4c8f58b07fd7c9b90c6b0f0c0ecbe8db69095a6079537a7/regex-2023.8.8.tar.gz"
    sha256 "fcbdc5f2b0f1cd0f6a56cdb46fe41d2cce1e644e3b68832f3eeebc5fb0f7712e"
  end

  resource "tblib" do
    url "https://files.pythonhosted.org/packages/64/e3/d9aebe40d15d2c4c73a0ff8555326ef42a62ce3e5320ceb1aa762e4fbb54/tblib-2.0.0.tar.gz"
    sha256 "a6df30f272c08bf8be66e0775fad862005d950a6b8449b94f7c788731d70ecd7"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlfluff --version")
    (testpath/"test.sql").write <<~EOS
      SELECT 1;
    EOS
    assert_match "All Finished!", shell_output("#{bin}/sqlfluff lint --dialect sqlite --nocolor #{testpath}/test.sql")
  end
end
