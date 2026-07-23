class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "df46cb8fbf4bc80289cabbf59e22a03948a65278c637573db3bc5e7acfd1966b"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbda9e2f530787bf8fd70762ca08efb46d62c2797d85d89e496341278a96e615"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "447a6bc238316f05ae3d03ce0d958aa11ab7dc5a9afb855fd5b9e63a21cc4001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c394010de722af4f788075577f32fdfce3dcfbca6e1d8b4ccdd677a55491fd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0a19f86cbd0e0823969bb007b6ab6898e6a41c453baecc97360afe450d2a2de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d283e891e6a1d4f90cb6ebf1a5c5230b4be167fa80228956654ae83c74eb07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05acec1e4469598de53102f0009da36200afe641e3a75d20071843a71c6373ab"
  end

  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.14"
  depends_on "vte3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
