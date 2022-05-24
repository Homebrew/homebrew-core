class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/3d/5d/750745bf042362d6af309d527ab84db760d2102e3b688bd0344e597b4fd1/shallow-backup-5.1.tar.gz"
  sha256 "1825be1ef34befc38739c5eaf3855c2476a5c4d0a94f3c6405a42946b60d5a4f"
  license "MIT"
  head "https://github.com/alichtman/shallow-backup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d29c5f55824c6a60f155dbb6920445bf892226d13a15da91d48d7da97b323d58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d04ca8458395850f89606442c28243e4677f2969745b3cabaffcdb7ba017a93"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e096257128a0888ce850265c079876ce0baa37880ce9530dc5271c3b2c5f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec92cdb1245b454a8ed3df44db3619a2843cf62b483268c312f264e439431491"
    sha256 cellar: :any_skip_relocation, catalina:       "cb356c99f421807322e73ff72e7a54eb66d0499ff27cf0bb409b6e30a48ee539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713ee458755ee85c536271cb5788edfdeedfdc05d7ca9030af6b3c0202e6b555"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/d2/44/13a1a790ff7433ad60f5d1a4867810e4411757ccc58fb1bf91465840d6ce/blessed-1.19.0.tar.gz"
    sha256 "4db0f94e5761aea330b528e84a250027ffe996b5a94bf03e502600c9a5ad7a61"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/34/cc/aaa7a0d066ac9e94fbffa5fcf0738f5742dd7095bdde950bd582fca01f5a/GitPython-3.1.24.tar.gz"
    sha256 "df83fdf5e684fef7c6ee2c02fc68a5ceb7e7e759d08b694088d0cacb4eba59e5"
  end

  # PyPi package doesn't contain requirements.txt - Hence GitHub package used
  resource "inquirer" do
    url "https://github.com/magmax/python-inquirer/archive/2.8.0.tar.gz"
    sha256 "11272d019970b054b09834d048792ce06ebff21d8a5b200d865d1e18bc8a88e7"
  end

  resource "python-editor" do
    url "https://files.pythonhosted.org/packages/0a/85/78f4a216d28343a67b7397c99825cff336330893f00601443f7c7b2f2234/python-editor-1.0.4.tar.gz"
    sha256 "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/16/2b/0cd0ba53d6dcdc4d69dcff68970c9b1347cc1d7f1c17ed4c15ec3a71a6e5/readchar-3.0.4.tar.gz"
    sha256 "3ce642ade5b61efee273b3c4bf55c77a84398178842627c74fcb796e1666ab13"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
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
