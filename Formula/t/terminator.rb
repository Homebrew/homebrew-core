class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "df46cb8fbf4bc80289cabbf59e22a03948a65278c637573db3bc5e7acfd1966b"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88c0ac27c2d76bbee8e2fa332e77c53169767e6612a1a10183ffde3ca8d3a5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "723e802e3f3f79400d8d5564719425af34680a00fd5746778755ba4614ee4bc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8ef4ddcb4294e55a9c0e28434ea5da8ff2ec3871d4ff9a01010425c1f28aa26"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf4b1433eaadee83312ad705ed311db2ab626b71f4751efa6a6c17383b39712"
    sha256 cellar: :any_skip_relocation, ventura:       "23c152d460198f9fa45f5f2c3e25a7ceb03eb6126c7527cba78a0f6632153de1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e7181f5ee199d5ab726987d98198938b4af7f960fa77fcd850a62967389b132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7453996d0c7658caae13ae6dbe0ec99c8d7944f7b5c7b154f21359c4c9a8fc7e"
  end

  depends_on "pygobject3"
  depends_on "python@3.13"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
