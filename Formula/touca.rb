class Touca < Formula
  include Language::Python::Virtualenv
  desc "Open source tool for regression testing complex software workflows"
  homepage "https://github.com/trytouca/trytouca/tree/main/sdk/python"
  url "https://files.pythonhosted.org/packages/c8/6d/e1986d8c9b4f6cd2b583d0df8bd1769989b5ce5cb91dcc613b0d187e4a7a/touca-1.8.7.tar.gz"
  sha256 "244a52be4cf4670077fda0b740ac067470745da7084c241bc619b332f771d940"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec705c52f0e6ba524accc758207a88c318a253684ea6f263bf8fa5ee4441d968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c984a912eaafcf41197c61f46ad77a813850b7d7d61457813e2296da75359ce8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "421ddaa43f82c1f016839d4244651e8bad83e7fbc2cd6c6a27c7d8d0b3adabfb"
    sha256 cellar: :any_skip_relocation, ventura:        "d08d72bb9fa83fdd66e0e95acbe6893b8ec1b77b7126f04318c180ee4edeeaf5"
    sha256 cellar: :any_skip_relocation, monterey:       "82a55a409520005663f80a747c9a3a2e6c1e338cd4640e10fd2b30724b6dc27a"
    sha256 cellar: :any_skip_relocation, big_sur:        "444eaa7c72956bff42d5e615fd9faa719b24cfc007df94c545e347fc38ef67cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e7ca51c66bf0bea069149bbbec11cecc77b0fc834dfb031c1714db914002ad"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "flatbuffers" do
    url "https://files.pythonhosted.org/packages/0d/0a/2e88943de46df2d69a037427099323a973489d4697058043e99ace188f3b/flatbuffers-23.1.21.tar.gz"
    sha256 "a948913bbb5d83c43a1193d7943c90e6c0ab732e7f2983111104250aeb61ff85"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/11/23/814edf09ec6470d52022b9e95c23c1bef77f0bc451761e1504ebd09606d3/rich-12.6.0.tar.gz"
    sha256 "ba3a3775974105c221d31141f2c116f4fd65c5ceb0698657a11e9f295ec93fd0"
  end

  resource "touca-fbs" do
    url "https://files.pythonhosted.org/packages/0e/ae/c5bd348bf8c21d5696538261dc8c05fc5e5a7d60056ecf7180c590d02bd1/touca_fbs-0.0.3.tar.gz"
    sha256 "f9d31d0498bff34637356dcd567ae026e9f10d24ee806bf2e020be49b472779d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/touca version")
    assert_empty shell_output("#{bin}/touca profile set test-profile")
    assert_empty shell_output("#{bin}/touca config set some-key=some-value")
    assert_match "some-key", shell_output("#{bin}/touca config show")
    assert_match "some-value", shell_output("#{bin}/touca config show")
    assert_match "test-profile", shell_output("#{bin}/touca profile ls")
    assert_empty shell_output("#{bin}/touca profile rm test-profile")
  end
end
