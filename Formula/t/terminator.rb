class Terminator < Formula
  include Language::Python::Virtualenv

  desc "Multiple GNOME terminals in one window"
  homepage "https://gnome-terminator.org"
  url "https://github.com/gnome-terminator/terminator/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "0de6024112f56fee9f86a1606309903be30e1018c83390444971c78b1730897c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41bacb04458545a8959686d114b5f533559879148de22d4eb1b82a0739502936"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "411920983a7e149c030ff16a08b38a2b3ecaa6e3bddee4dc9d644da7d6322cc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "487b99dd3b096cae9db5e29a6eaec08098031ec7187830e67aa5125fa05503f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "a2fb445a6ee48645d18691eb7665bdd864184ea617fd9a80b131767765a24918"
    sha256 cellar: :any,                 arm64_linux:       "b48513bf076d0edb03f4555f326799fec466d57d8f718e3537d8a2fa4f705573"
    sha256 cellar: :any,                 x86_64_linux:      "3178192dc2ac7b03c124d600fca7edc86e26519be589c3474b7932f1e3ec6235"
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
    (testpath/"version_check.py").write <<~PYTHON
      from terminatorlib.version import APP_VERSION
      print(APP_VERSION)
    PYTHON
    assert_match version.to_s, shell_output("#{libexec}/bin/python version_check.py")
    terminator = bin/"terminator"
    assert_path_exists terminator
    return if OS.mac? # terminator within macOS sandbox crashes without any output

    pid = Process.spawn terminator, "-d", [:out, :err] => "#{testpath}/output"
    begin
      sleep 10
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    output = "You need to run terminator in an X environment. Make sure $DISPLAY is properly set"
    assert_match output, (testpath/"output").read
  end
end
