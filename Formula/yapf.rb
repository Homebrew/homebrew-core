class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/7a/cb/7675e1d2788ce93246f8c2e0e6ed00019c86853f92dc9226a90e0e1a1e95/yapf-0.40.0.tar.gz"
  sha256 "7eeb8c404e386f16e24cbd785103dbc573f51cbb68e65a35f4392e0233f3d7bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d94edba2aa3f312400cb2052e2d06b681934ce129ffd9cd10121433087fd9025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8586415ede493322d25f331243d5c4a414478f0592f15c374ecf6bf66e2d429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f44cb2fe57107ae36b5db7b9c1f3fa872979d81a1adc9eb9fc5731c0c183729b"
    sha256 cellar: :any_skip_relocation, ventura:        "a7458aab0ccaadf00f6893c60efbbb8472bb76785917af41154c0ae6be3bf627"
    sha256 cellar: :any_skip_relocation, monterey:       "cef5ad2a599e78703379b69593bad443bc21ed185b4d46ef6d177ee28ac33f17"
    sha256 cellar: :any_skip_relocation, big_sur:        "70bdfd814ea123998380d6a59c5205979551e8e9ea2c5ae68e6d0a5a1eb1f29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f24badd2b57c365ea0ce2e6497e746f6f7b9842449889d40e9b735d95eea8b0"
  end

  depends_on "python@3.11"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0b/1f/9de392c2b939384e08812ef93adf37684ec170b5b6e7ea302d9f163c2ea0/importlib_metadata-6.6.0.tar.gz"
    sha256 "92501cdf9cc66ebd3e612f1b4f0c0765dfa42f0fa38ffb319b6bd84dd675d705"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d2/5d/29eed8861e07378ef46e956650615a9677f8f48df7911674f923236ced2b/platformdirs-3.5.3.tar.gz"
    sha256 "e48fabd87db8f3a7df7150a4a5ea22c546ee8bc39bc2473244730d4b56d2cc4e"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  # upstream patch PR, https://github.com/google/yapf/pull/1108
  # remove this resource in next release
  resource "grammar-txt" do
    url "https://raw.githubusercontent.com/google/yapf/main/third_party/yapf_third_party/_ylib2to3/Grammar.txt"
    sha256 "b88c46ec8add7a6462f783ad4d4695a16da4b58c8acae5c796e58530cabc01fe"
  end

  resource "patterngrammar-txt" do
    url "https://raw.githubusercontent.com/google/yapf/main/third_party/yapf_third_party/_ylib2to3/PatternGrammar.txt"
    sha256 "ee5ba5db3b6722a0e2fbe2560ebc1c883e72328ef9c3b4da1c7c5d1cc649bce3"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    filtered_resources = resources.reject { |r| (r.name == "grammar-txt") || (r.name == "patterngrammar-txt") }
    venv.pip_install filtered_resources
    venv.pip_install_and_link buildpath

    site_packages = Language::Python.site_packages("python3.11")
    (libexec/site_packages/"yapf_third_party/_ylib2to3").install resource("grammar-txt")
    (libexec/site_packages/"yapf_third_party/_ylib2to3").install resource("patterngrammar-txt")
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
