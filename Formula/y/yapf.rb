class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
  sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c34419fe93349e8837dcbe1ad35d183aa413796d47080335f2dd6c065281434"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "422b8ce66d2556d2250a30c4086a3f1510fddd7a97deefb95bdd154e4882af0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b808aa89fcbf890442c1becaf32eb3c95e2b2ff651103d82ee7fe620bd53a0a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "837abfa1a367e7e560be0dbd6f9a157a9e28626b52238cb5d3f1a16d826faf75"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dfabf134af287ea1ca6cbadd00b8c84c9a3be4bab21056138c3a48fafb861dc"
    sha256 cellar: :any_skip_relocation, ventura:        "b9076b4b9e266bc54e512498bee3f7e14bbf9ba25db515468c0e4aa1c226e072"
    sha256 cellar: :any_skip_relocation, monterey:       "7f9f5e2ab1832448d5125d14ad02c30ea2a19c656fd29b134dec7d6ff30d0608"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a84d0b4d1786841e502e890bd0758ff5878b6e311b2957ed46030993f25832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0096f1ba0a8ada09d41a5ad0ff4a1759b96888a492694f309594ed8de7c2678"
  end

  depends_on "python@3.11"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
