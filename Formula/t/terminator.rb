class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "b6a544426a19829f9e9bb41441a2f4789edc04f1867c84a436822d1af6a36d06"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d823e29f9a03f186e2ff84443aca3348821632cab7a085068146bd0403383fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241380e6ab7728c4cb1b46bf8a569a0a8527a4b4e97fbfab7fcd78a658c5bbe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5440ad3063e68abe0e0bf3796021dfbbd4bae5f07c1c013f0265c47e0dcdcace"
    sha256 cellar: :any_skip_relocation, sonoma:        "a18e427816b26610cec97cd87bf1915ee7aec6a86c2af90295a3bf0a5130ddd7"
    sha256 cellar: :any_skip_relocation, ventura:       "60f289ff7f318d749a0523fbcb094c694ec1db2700ad6ee6899774d61dfe3fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f308e8367d3813ca6b6ec3d46852877fb293163656b8b5b725ee042602b1480f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73119f14b2225e8557fb354ac8d53d1f58579893bbb69e1e74ddbfca62eede9e"
  end

  depends_on "pygobject3"
  depends_on "python@3.13"
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
