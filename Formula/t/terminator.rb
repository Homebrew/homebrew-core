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
  depends_on "python-psutil"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
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
