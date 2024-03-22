class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ba499365147f501ab12e495af14d5099aee0b378454b4764bd2e3bb6052b6394"
  license "GPL-2.0-only"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80e72e1494c20a2b7af3fa0b05d8ccba0f3ac7535fc63ba571dcbc8ced59fa38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d52cedeac8cdc339026a89a340758e96aff186f44adc3379065b7de9baabac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ac084ee51b80ca0fa7e79aeeffd5991410b3f72bbb1c1bb2152ad0ca320ae0"
    sha256 cellar: :any_skip_relocation, sonoma:         "b385d049fc9609bfdecae76d6aea79a430d679092d42f82b584e30d705e6e160"
    sha256 cellar: :any_skip_relocation, ventura:        "d907e535fab50b660a77b1c680c73963d6ffc7e69d109fa6a3d84b152644f7fe"
    sha256 cellar: :any_skip_relocation, monterey:       "52c72d278ac0a012ad2a6d85fe9e04f4de45e7daec8ec47ce74a31d51d50a304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c1b9e9be39bbf308993a1469d1dc55c2ff2a69f04ce74a014383bb7616b60d5"
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
