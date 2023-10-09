class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/eb/33/4b56af73e95125cd6d92972a3e55c82f3ac9386d3401dd198f886a99bb0e/shallow-backup-6.0.tar.gz"
  sha256 "8fa5b8052c9f9c4f4ef456cf2f0163ef0fffb5c3a96e506665bae7899b5cc72c"
  license "MIT"
  revision 3
  head "https://github.com/alichtman/shallow-backup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8d724b4b026d20c62495c2652e896bf3acfa8e4e81d4cfa3dc4264e055e2e92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2613e74af6a3d9199e46883b09c95178cd74667d22d8e56f69c993df864a9218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e76a8f891ea5e97d0ed18e671572fb0777b6a089f6f1d67dfa3ce2d1564f4152"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac1d24115ea3dd8e129f4bf19f1cc1ec98c2eaff00196c1313a48e8aac7c2f65"
    sha256 cellar: :any_skip_relocation, ventura:        "b518a273984cac67f1cffe3acbdc4fe0fa337e4749ae4bce6cf94a9455c8057c"
    sha256 cellar: :any_skip_relocation, monterey:       "f3ffb30d7fe69773ca9235c7494c6fed5cf38acddad7a1af3a6dc40a36b400a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d056dd75c7eefa3faa3a5d2d5ad40b5a47eb7f75e4371bba728f4a7cf21555da"
  end

  depends_on "python@3.12"
  depends_on "six"

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

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c6/33/5e633d3a8b3dbec3696415960ed30f6718ed04ef423ce0fbc6512a92fa9a/GitPython-3.1.37.tar.gz"
    sha256 "f9b9ddc0761c125d5780eab2d64be4873fc6817c2899cbcb34b02344bdc7bc54"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/1b/e3/e2998fad3add25dc7dad7decb8dcd92e71888d7e9514c647d0a461a7381c/inquirer-3.1.3.tar.gz"
    sha256 "aac309406f5b49d4b8ab7c6872117f43bf082a552dc256aa16bc95e16bb58bec"
  end

  resource "python-editor" do
    url "https://files.pythonhosted.org/packages/0a/85/78f4a216d28343a67b7397c99825cff336330893f00601443f7c7b2f2234/python-editor-1.0.4.tar.gz"
    sha256 "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/a1/57/439aaa28659e66265518232bf4291ae5568aa01cd9e0e0f6f8fe3b300e9e/readchar-4.0.5.tar.gz"
    sha256 "08a456c2d7c1888cde3f4688b542621b676eb38cd6cfed7eb6cb2e2905ddc826"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
  end

  def install
    virtualenv_install_with_resources

    # Patch `python-editor` to support 3.12
    # https://github.com/fmoo/python-editor/pull/39
    inreplace libexec/Language::Python.site_packages("python3.12")/"editor.py",
      "from distutils.spawn import find_executable",
      "from shutil import which as find_executable"
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
    assert_match "test.svg", shell_output("#{bin}/shallow-backup --show")
  end
end
