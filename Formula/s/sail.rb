class Sail < Formula
  include Language::Python::Virtualenv

  desc "CLI toolkit to provision and deploy WordPress applications to DigitalOcean"
  homepage "https://sailed.io"
  url "https://files.pythonhosted.org/packages/14/a7/7f3f93ab1d8d9f58e8dce01ff5bbbdaf5f6ce679e5e13638df0cd2bdbe9a/sailed.io-0.10.8.tar.gz"
  sha256 "c31f7adbf97ea4c2827e35f9615a54fe9a013bd0b16a655ad29a926d9f86f014"
  license "GPL-3.0-only"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "683b664520bdc527c8cf90bae1446c4d18fb1cf3c029c36f63f1119dd2e058c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4353778cb21326a1a538d3b23b4eaa892326a6dc6e1cafcf53adf934be241cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac7adb6bca5a5123896d7e6ba6b3e084bb95f2e4ba06970a937623745d72c195"
    sha256 cellar: :any_skip_relocation, sonoma:         "def6f099466e8475b882eaa362bf05648a44a9377e7d1aa43c3b2725fb0b3d62"
    sha256 cellar: :any_skip_relocation, ventura:        "378c2c8300ff86429bb2ea773d25896d63505b7d2617ba090cb564aa12846229"
    sha256 cellar: :any_skip_relocation, monterey:       "997a26c5b0fd84761e8fd68025819e21db4a7ba37c982e9f4aedbe95e7ae274b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6b5188c8d5c6dabfdde6fbc37cf9d6c8631440034042eb97c57d0744ac2271"
  end

  depends_on "fabric"
  depends_on "pyinvoke"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-filelock"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/6e/92/62fdc2f6b468b870dd171ad21748ef0ec2bff1b258c25ce6db3545cccc90/jsonpickle-3.0.2.tar.gz"
    sha256 "e37abba4bfb3ca4a4647d28bb9f4706436f7b46c8a8333b4a718abafa8e46b37"
  end

  resource "python-digitalocean" do
    url "https://files.pythonhosted.org/packages/f8/f7/43cb73fb393c4c0da36294b6040c7424bc904042d55c1b37c73ecc9e7714/python-digitalocean-1.17.0.tar.gz"
    sha256 "107854fde1aafa21774e8053cf253b04173613c94531f75d5a039ad770562b24"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/50/5c/d32aeed5c91e7970ee6ab8316c08d911c1d6044929408f6bbbcc763f8019/requests-file-1.5.1.tar.gz"
    sha256 "07d74208d3389d01c38ab89ef403af0cfec63957d53a0081d8eca738d0247d8e"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/ba/7a/dc3ffc0e333d33e8ccb63a14adc40180c29d89490a25ebe9f9ef01605c51/tldextract-3.6.0.tar.gz"
    sha256 "a5d8b6583791daca268a7592ebcf764152fa49617983c49916ee9de99b366222"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    site_packages = Language::Python.site_packages(python3)
    fabric = Formula["fabric"].opt_libexec
    (libexec/site_packages/"homebrew-fabric.pth").write fabric/site_packages

    venv.pip_install_and_link buildpath

    generate_completions_from_executable(bin/"sail", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    xy = Language::Python.major_minor_version "#{libexec}/bin/python"
    unittest = "#{libexec}/bin/python -m unittest discover " \
               "#{libexec}/lib/python#{xy}/site-packages/sail/tests 2>&1"

    assert_match(version.to_s, shell_output("#{bin}/sail --version"))
    assert_match("Could not parse .sail/config.json", shell_output("#{bin}/sail deploy 2>&1", 1))
    assert_match("OK", shell_output(unittest))
  end
end
