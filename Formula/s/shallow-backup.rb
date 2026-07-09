class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/16/25/621fbd73cadb2e18f56ea89ae602b2c93d88c77d9858ae16f541c523e9b3/shallow_backup-6.6.tar.gz"
  sha256 "016e85303accffc24b72a64cf589ff48d962298d60a37759d2302b81f7fbb8b3"
  license "MIT"
  revision 2
  head "https://github.com/alichtman/shallow-backup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2dde7e4b810415b9d6150564c8540a856f76c6c9d2786f56fac3bea6182e60bf"
  end

  depends_on "maturin" => :build # for `editor`
  depends_on "rust" => :build # for `editor`
  depends_on "python@3.14"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/94/ca/47457ccbfeac62002079ebc47509e1eccd5c8ec764c78975c7afd81c6b4a/blessed-1.39.0.tar.gz"
    sha256 "b04fc7141a20a3b2ade6cad741051f1e3ac59cc1e7e90915ed1f9e521332bea4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/d9/4f/00e0b75d86bb1e6a943c08942619e3f31de54a0dce3b33b14ae3c2af2dc0/editor-1.7.0.tar.gz"
    sha256 "979b25e3f7e0386af4478e7392ecb99e6c16a42db7c4336d6b16658fa0449fb3"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/33/f6/354ae6491228b5eb40e10d89c4d13c651fe1cf7556e35ebdded50cff57ce/gitpython-3.1.50.tar.gz"
    sha256 "80da2d12504d52e1f998772dc5baf6e553f8d2fcfe1fcc226c9d9a2ee3372dcc"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/c1/79/165579fdcd3c2439503732ae76394bf77f5542f3dd18135b60e808e4813c/inquirer-3.4.1.tar.gz"
    sha256 "60d169fddffe297e2f8ad54ab33698249ccfc3fc377dafb1e5cf01a0efb9cbe5"
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
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/8b/3f/0bc3b89c1dd4dee1f954db4c857f8fbe9cdfa8b25efe370b6d78399a93ac/xmod-1.9.0.tar.gz"
    sha256 "98b2e7e8e659c51b635f4e98faf3fa1f3f96dab2805f19ddd6e352bbb4d23991"
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
