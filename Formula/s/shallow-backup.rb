class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/d0/56/427960ea933c35b43b561d8f1379d4f7794b67f785ec3137adaf6ce5073e/shallow_backup-6.4.tar.gz"
  sha256 "b933d19d7238d04eb1bf3943078ee74933dbe6faf2d5b503a865242d0d6bd2e6"
  license "MIT"
  head "https://github.com/alichtman/shallow-backup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c6b568aadef08c73903fa4e63af2f185767d01cc49d934357e1e948370440e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22c6b568aadef08c73903fa4e63af2f185767d01cc49d934357e1e948370440e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22c6b568aadef08c73903fa4e63af2f185767d01cc49d934357e1e948370440e"
    sha256 cellar: :any_skip_relocation, sonoma:        "faeb8b9d1a0e93fea36e1e93aa473374e598abe938716db7329c80a6be0f2a34"
    sha256 cellar: :any_skip_relocation, ventura:       "faeb8b9d1a0e93fea36e1e93aa473374e598abe938716db7329c80a6be0f2a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef099a4f31fbc2d802d7d076c9d809d4368b86bcfc8052a6e277b14c1ff71a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22c6b568aadef08c73903fa4e63af2f185767d01cc49d934357e1e948370440e"
  end

  depends_on "python@3.13"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/2a/92/734a4ab345914259cb6146fd36512608ea42be16195375c379046f33283d/editor-1.6.6.tar.gz"
    sha256 "bb6989e872638cd119db9a4fce284cd8e13c553886a1c044c6b8d8a160c871f8"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/b6/a1/106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662/GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/f3/06/ef91eb8f3feafb736aa33dcb278fc9555d17861aa571b684715d095db24d/inquirer-3.4.0.tar.gz"
    sha256 "8edc99c076386ee2d2204e5e3653c2488244e82cb197b2d498b3c1b5ffb25d0b"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/18/31/2934981710c63afa9c58947d2e676093ce4bb6c7ce60aac2fcc4be7d98d0/readchar-4.2.0.tar.gz"
    sha256 "44807cbbe377b72079fea6cba8aa91c809982d7d727b2f0dbb2d1a8084914faa"
  end

  resource "runs" do
    url "https://files.pythonhosted.org/packages/26/6d/b9aace390f62db5d7d2c77eafce3d42774f27f1829d24fa9b6f598b3ef71/runs-1.2.2.tar.gz"
    sha256 "9dc1815e2895cfb3a48317b173b9f1eac9ba5549b36a847b5cc60c3bf82ecef1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/72/b2/e3edc608823348e628a919e1d7129e641997afadd946febdd704aecc5881/xmod-1.8.1.tar.gz"
    sha256 "38c76486b9d672c546d57d8035df0beb7f4a9b088bc3fb2de5431ae821444377"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      bin/"shallow-backup",
      shells:                 [:fish, :zsh],
      shell_parameter_format: :click,
    )
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
