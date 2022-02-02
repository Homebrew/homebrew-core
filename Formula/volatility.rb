class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/00/61/272892bd1b5396370260042c486bc0914074c53c86c497588aa6a4526409/volatility3-2.0.0.tar.gz"
  sha256 "05b19ae8f7928f24acb4f4a430ebf817096fe73cf655d3d6830cc3c6e7a4e53f"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    sha256 cellar: :any, catalina:    "f41ce1f3f70a5bb1eab7efac3d74ace7dad7bdf581bcb16b7a09d34e27e38d50"
    sha256 cellar: :any, mojave:      "5bcfa94349a26dc291af274bcf3427851ed2654e36781d05e3774018ee8f7781"
    sha256 cellar: :any, high_sierra: "0d156b81c472080d117d567167d7a6d294376bab6d3c4751b4ca343a25fefa3d"
  end

  depends_on "jsonschema"
  depends_on "python@3.10"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "capstone" do
    url "https://files.pythonhosted.org/packages/f2/ae/21dbb3ccc30d5cc9e8cdd8febfbf5d16d93b8c10e595280d2aa4631a0d1f/capstone-4.0.2.tar.gz"
    sha256 "2842913092c9b69fd903744bc1b87488e1451625460baac173056e1808ec1c66"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/ee/e1/a7bd302cf5f74547431b4e9b206dbef782d112df6b531f193bb4a29fb1b9/pefile-2021.9.3.tar.gz"
    sha256 "344a49e40a94e10849f0fe34dddc80f773a12b40675bf2f7be4b8be578bdd94a"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/7e/1a/0dd70814ba29f7f6511a32d168d7fe9a175166ee92459869e03c6daeacd4/pycryptodome-3.14.0.tar.gz"
    sha256 "ceea92a4b8ba6c50d8d70f2efbb4ea14b002dac4160ce4dda33f1b7442f8158a"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/bb/52/792913c765ea17bdaf3d91fb2b358a337acf8403079b57329c41f1848213/yara-python-4.1.3.tar.gz"
    sha256 "348d80039c3b499ad8ec9ce02ceaef0c1d5b7282b84e3b6fe6adb6a158c8e0cf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
