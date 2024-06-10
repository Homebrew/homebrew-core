class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "b6a544426a19829f9e9bb41441a2f4789edc04f1867c84a436822d1af6a36d06"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "977d208ffe8ac59d8a5ff0ef577ac0e6e6af388ca5bd637632227ad232a72326"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d7be7db387a5e11d7ed9f6f6e08c5638ec484680d923a2486f12f993ff1ded4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c059276169ab3dc9d3307fd648252ea3f10ab046cab0c51b3f0fa7cd8a386ff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e0770ff214ee3b3d0ea6d3674ede07b7a27216f933f1d5bfb7391c5c537dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "af1cf0b858e2341d6c5686d7eb36c6c277dbf3eb60522cb22fa58e62b5a5031b"
    sha256 cellar: :any_skip_relocation, monterey:       "d9eebb2a1316d84ea194f18a2b0870c7cb332f3f0a513d656f518f84e48f6b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5eb10e4a24584a4db44a6f84d7f355dff428f380bed522ed69a44e373f78a9"
  end

  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c8/1f/e026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44/setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    pid = Process.spawn bin/"terminator", "-d", [:out, :err] => "#{testpath}/output"
    sleep 30
    Process.kill "TERM", pid
    output = if OS.mac?
      "Window::create_layout: Making a child of type: Terminal"
    else
      "You need to run terminator in an X environment. Make sure $DISPLAY is properly set"
    end
    assert_match output, File.read("#{testpath}/output")
  ensure
    Process.kill "KILL", pid
  end
end
