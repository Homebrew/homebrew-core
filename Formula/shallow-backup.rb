class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://github.com/alichtman/shallow-backup/archive/v5.0.1.tar.gz"
  sha256 "a4f2e2702ca656d43852b26a85e7ae0056f7c89297b1288b11c0526449c62f8e"
  license "MIT"
  head "https://github.com/alichtman/shallow-backup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "229b33c4ec8ca8298b4a6fdf88161d2cb7023399af7adeaf445516557e9dea8c" => :catalina
    sha256 "d5e2a09b5c4cf1da508b1e18f44d1509f70313e7b831f38424db2e67367907fd" => :mojave
    sha256 "bf8b92d72f9e051d036ad04386ecf753191732342f92618b7b80238c8f00738b" => :high_sierra
  end

  depends_on "python@3.8"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/20/6b/80d2704532134a0acf513a2804d342686a66a779d28822eb48346dc2a861/blessed-1.17.6.tar.gz"
    sha256 "a9a774fc6eda05248735b0d86e866d640ca2fef26038878f7e4d23f7749a1e40"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/d1/05/eaf2ac564344030d8b3ce870b116d7bb559020163e80d9aa4a3d75f3e820/gitdb-4.0.5.tar.gz"
    sha256 "c9e1f2d0db7ddb9a704c2a0217be31214e91a4fe1dea1efad19ae42ba0c285c9"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/53/ea/fc34cddaa30bfc5e283f13e754fb3e2648ccd9f7019eaa3518fb5350ae51/GitPython-3.1.7.tar.gz"
    sha256 "2db287d71a284e22e5c2846042d0602465c7434d910406990d5b74df4afb0858"
  end

  # PyPi package doesn't contain requirements.txt - Hence GitHub package used
  resource "inquirer" do
    url "https://github.com/magmax/python-inquirer/archive/2.7.0.tar.gz"
    sha256 "0ed6c9ee4a6eab6d914dfe08903430066a2222234ca0146760471270d93f0992"
  end

  resource "python-editor" do
    url "https://files.pythonhosted.org/packages/0a/85/78f4a216d28343a67b7397c99825cff336330893f00601443f7c7b2f2234/python-editor-1.0.4.tar.gz"
    sha256 "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b"
  end

  # There's no tar.gz on PyPi
  resource "readchar" do
    url "https://github.com/magmax/python-readchar/archive/2.0.0.tar.gz"
    sha256 "503c96fbdaa5e96162535dc0a8fb8525582a18a42214909d751f150c8029d694"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/75/fb/2f594e5364f9c986b2c89eb662fc6067292cb3df2b88ae31c939b9138bb9/smmap-3.0.4.tar.gz"
    sha256 "9c98bbd1f9786d22f14b3d4126894d56befb835ec90cef151af566c7e19b5d24"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Creates a config file and adds a test file to it
    # There is colour in stdout, hence there are ANSI escape codes
    assert_equal "\e[34m\e[1mCreating config file at: \e[22m#{pwd}/.config/shallow-backup.conf\e[0m\n" \
    "\e[34m\e[1mAdded: \e[22m#{test_fixtures("test.svg")}\e[0m",
    shell_output("#{bin}/shallow-backup --add-dot #{test_fixtures("test.svg")}").strip

    # Checks if config file was created
    assert_predicate testpath/".config/shallow-backup.conf", :exist?

    # Checks if the test file is in the config
    system "shallow-backup -show | grep test.svg"
  end
end
