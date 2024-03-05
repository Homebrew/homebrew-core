class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "ba499365147f501ab12e495af14d5099aee0b378454b4764bd2e3bb6052b6394"
  license "GPL-2.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dff737de0e39a66a68516b65d361919e9054ae1847eb43a6558869007081afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2ada86b47390bce284bf46657f6915fe329f3e999c37726bc631774adfe221"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e30f676dabd280e0768ea3518875ab97250fda781466e1979e9e609d001b9e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3d91d55179719584da179fff6ce4a0b0e40f128d579a5369fa17c2014ebe45b"
    sha256 cellar: :any_skip_relocation, ventura:        "9c4642834e09878bea7ed5b707021d6619b172cce55df492f511a42eb9921338"
    sha256 cellar: :any_skip_relocation, monterey:       "954aec79973199ab4f95dd705ec369e52424445476c71bc91c07917ad366655c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e39dc4193694eede7839f8d3f6909b7fcd379e560a305e33d06cc35d2d7dbbe4"
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
