class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/20/e2/3f823c1394acf9e22d1f0e700d0edf3398209e99c04f69bcd50c279913ea/virtualenv-21.15.14.tar.gz"
  sha256 "6c6e7aaf88064767c75c32a9df92eaa425cee5db4cc21caf031a78d89375d57f"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    manifest_sha256 "bceca085b1ea6d9cac719a8dda7790c95c25952f169098561b63b5c495e2eb4b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "239c128c1f5276a358b613540487abd991f0bbf4f13c075c06e554c0bb7b4ff8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "239c128c1f5276a358b613540487abd991f0bbf4f13c075c06e554c0bb7b4ff8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "239c128c1f5276a358b613540487abd991f0bbf4f13c075c06e554c0bb7b4ff8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "468fb9b6cc70f3eb427d2833275b297191bf04bf30ab22fe68691d9d756f5725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "468fb9b6cc70f3eb427d2833275b297191bf04bf30ab22fe68691d9d756f5725"
  end

  depends_on "python@3.15"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/68/bc/d36966de7304047a1001a7559fbf266c464bb5d8cc85464536ef8c9bcc32/distlib-0.4.4.tar.gz"
    sha256 "ca4175b4ac7f71223cc30ed7248c45d2b38c2439d8ee6e498ab67ed63cf3508d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b2/de/99f4266dc2b97503fe35af46d4bf54ea4d434bc322992103145c9de7da95/filelock-4.3.2.tar.gz"
    sha256 "4f0a21c70447782453c06bb20a9863ee385ead1abaef22049af79289496851b3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d6/96/549558270586699a271a18b1111482dc3fc39baa0ef61d183e230d2c961d/platformdirs-4.14.9.tar.gz"
    sha256 "c6b188e03ffd4dfe1bf8c4bcb47cd94711af244a9852dbff60297bd753684d5d"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/72/8e1d062fa1eed059b49a981394ab3ae26fffea6bbcffa4f7545aa2fb8c4f/python_discovery-1.9.7.tar.gz"
    sha256 "cea89e8a8b86e19731c67f8393f34eb1a2f96c9f97f3e406929a99c646a2358d"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
