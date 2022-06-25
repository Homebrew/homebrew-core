class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/2d/82/57f4cbb74da06af37773461da10cccd7163d67293750b2c977931d6d32ea/shallow-backup-5.2.tar.gz"
  sha256 "2cd7b9f6f2d8d8c143403ca3b0d58aa27ce877e461eacdd26bb379d08747a0c9"
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
    url "https://files.pythonhosted.org/packages/e5/ad/97453480e7bdfce94f05a983cf7ad7f1d90239efee53d5af28e622f0367f/blessed-1.19.1.tar.gz"
    sha256 "9a0d099695bf621d4680dd6c73f6ad547f6a3442fbdbe80c4b1daa1edbc492fc"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/fc/44/64e02ef96f20b347385f0e9c03098659cb5a1285d36c3d17c56e534d80cf/gitdb-4.0.9.tar.gz"
    sha256 "bac2fd45c0a1c9cf619e63a90d62bdc63892ef92387424b855792a6cabe789aa"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d6/39/5b91b6c40570dc1c753359de7492404ba8fe7d71af40b618a780c7ad1fc7/GitPython-3.1.27.tar.gz"
    sha256 "1c885ce809e8ba2d88a29befeb385fcea06338d3640712b59ca623c220bb5704"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/4a/3a/8028f3f48e314c89d2153d05e7a2e6e79a31bdf0f5332af3af8df9f306cc/inquirer-2.9.2.tar.gz"
    sha256 "4a53cb9386601476e9f3241adace469ae6d1143ace2ee82f2768149e85861ab8"
  end

  resource "python-editor" do
    url "https://files.pythonhosted.org/packages/0a/85/78f4a216d28343a67b7397c99825cff336330893f00601443f7c7b2f2234/python-editor-1.0.4.tar.gz"
    sha256 "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/8d/ff/33df88cee8ab693302288fc7d2983e561bf7d78439b844407c976d52fa73/readchar-3.0.5.tar.gz"
    sha256 "d1f5b71e98c37b7f3b695fba9db978ab84f4f8a0ed879653d83e1d90a4c482c0"
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
