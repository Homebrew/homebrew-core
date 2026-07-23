class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/16/25/621fbd73cadb2e18f56ea89ae602b2c93d88c77d9858ae16f541c523e9b3/shallow_backup-6.6.tar.gz"
  sha256 "016e85303accffc24b72a64cf589ff48d962298d60a37759d2302b81f7fbb8b3"
  license "MIT"
  revision 3
  head "https://github.com/alichtman/shallow-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2af6dbd083a583440a8f2f618bc780193b8852198cf09f35fe8fb74e4cf75f59"
  end

  depends_on "maturin" => :build # for `editor`
  depends_on "rust" => :build # for `editor`
  depends_on "python@3.14"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/82/45/ad23d265373cdb7f255d2e3ed5f122b62914bd3c425bb21bca01ef699e5c/blessed-1.47.0.tar.gz"
    sha256 "ea13e06ae40f24710325411c5fa9b689d215cf170276cf1fda41feddaec8d3e0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/ae/5f/fe06c2a13a5282dcef4c7133bb348d4125a9aa69c5fb49037a004599d73a/editor-1.8.0.tar.gz"
    sha256 "b07e1bbcb8b33f05c2e6ed3ce77ee9756354ada840a18aad7c0536d967fe4c0b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/17/24/0e0c12cb6f7cb864779a9d2fefee9ca91838f6db402c8780c9d28a8d7ebe/gitpython-3.1.53.tar.gz"
    sha256 "06ae8d9623b0ed0d67b8adeac5c7008d0a5a404b087a9e0d0c7163bdd3a6b497"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/c1/79/165579fdcd3c2439503732ae76394bf77f5542f3dd18135b60e808e4813c/inquirer-3.4.1.tar.gz"
    sha256 "60d169fddffe297e2f8ad54ab33698249ccfc3fc377dafb1e5cf01a0efb9cbe5"
  end

  resource "jinxed" do
    url "https://files.pythonhosted.org/packages/39/d7/6e6d474ec5eaeca6a61acc17766bb19563b3a372b4b9d92910078f5fe49f/jinxed-2.1.0.tar.gz"
    sha256 "7e755b831faa2443d44fb4ce7c0202eb9c3ed39bd5bf1193365888f4f6092b54"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "runs" do
    url "https://files.pythonhosted.org/packages/f2/ae/095cb626504733e288a81f871f86b10530b787d77c50193c170daaca0df1/runs-1.3.0.tar.gz"
    sha256 "cca304b631dbefec598c7bfbcfb50d6feace6d3a968734b67fd42d3c728f5a05"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/7a/3b/5a0d2670bab661164e27a5c27c448ae6204458c97cb94ccf89d0c47715bc/xmod-1.10.0.tar.gz"
    sha256 "b40b2a54d56684b01eb9627892b0c179918e8ef0bd4d7f3bac7a3fdba11cd6e6"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"shallow-backup", shell_parameter_format: :click)
  end

  test do
    # Creates a config file and adds a test file to it
    # There is colour in stdout, hence there are ANSI escape codes
    test_config = testpath/".config/shallow-backup.json"
    assert_equal "\e[34m\e[1mCreating config file at: \e[22m#{test_config}\e[0m\n" \
                 "\e[34m\e[1mAdded: \e[22m#{test_fixtures("test.svg")}\e[0m",
    shell_output("#{bin}/shallow-backup --add-dot #{test_fixtures("test.svg")}").strip

    assert_match version.to_s, shell_output("#{bin}/shallow-backup --version")
  end
end
