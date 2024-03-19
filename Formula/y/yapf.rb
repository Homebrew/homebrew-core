class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/b9/14/c1f0ebd083fddd38a7c832d5ffde343150bd465689d12c549c303fbcd0f5/yapf-0.40.2.tar.gz"
  sha256 "4dab8a5ed7134e26d57c1647c7483afb3f136878b579062b786c9ba16b94637b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c6a0ade7d780a2cb5177cbd2a5889341d0818a25a1610414c9e3d874b05617d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4ae82c3715aec9adbbb2c923a83e97d67cd891de2cb576c53b6c2a416afff9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5088a7f86428d893db8e5c55bc8d7261a2ff90424abdf8b6ccedfb322bbdbb74"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bc4b9eb238bad289eb53b283a5cacf3ea63a38a6005200faf87da960ae6036c"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e979502ef7269df066c1c794dbca76f4cd539f105429f7678a51a3e606613e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e0d791e2074b168e53ae9819611c2464b4ca3f4f4f13a19bd2af72b5f5b7d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5804753090e2cbb020abf4bef0d3f05c4f2b17c0a46a770c50dba111c3f7dcfd"
  end

  depends_on "python@3.12"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/33/44/ae06b446b8d8263d712a211e959212083a5eda2bf36d57ca7415e03f6f36/importlib_metadata-6.8.0.tar.gz"
    sha256 "dbace7892d8c0c4ac1ad096662232f831d4e64f4c4545bd53016a3e9d4654743"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
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
