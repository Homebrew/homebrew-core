class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/96/d7/c59ad086eabfc1b2984e32cc2615368f9ab0b375b8fc5a7a63e5ca81c017/shallow-backup-5.3.tar.gz"
  sha256 "0af200e5c2d1887e9209bfd970a6835d1d304cc22183569613f378f00848cfe1"
  license "MIT"
  head "https://github.com/alichtman/shallow-backup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a2492b461b1d87eddb49a0e4ab40ef8b190534d6e1099ee77ae911314df60e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95516355dcc3104cbcd281de234fd2da04453fb87ac9ae361b2b1cd407ed9f3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af25f9064dbe01dbb07ea2193552949d793412bb0caca81e9e5c400d282d9118"
    sha256 cellar: :any_skip_relocation, ventura:        "226758d858d2b74af070faa17318640734f4e248a30b23016f28fd7eb6d643cf"
    sha256 cellar: :any_skip_relocation, monterey:       "62d9ced2450c7d5e54cecee708c52702f710aab25501f6750ea0daa4babc4423"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd12ad190208a24871f6aa7e95f1af096f00601c0f926c6ae657294c01fc167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8df8ff954a6fefd42c44bf2486bd319bfba4deac071dcb71c01357962a928c1"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/9f/aa/ac9ffe7c70ece25ee552879a6132756de0cbda506e61aa9e4d4ee17be075/inquirer-3.1.2.tar.gz"
    sha256 "d5b4dafe5cbb9edf5991b77bd08053b683e13b600bf9174c0bda5a35b3e88ec5"
  end

  resource "python-editor" do
    url "https://files.pythonhosted.org/packages/0a/85/78f4a216d28343a67b7397c99825cff336330893f00601443f7c7b2f2234/python-editor-1.0.4.tar.gz"
    sha256 "51fda6bcc5ddbbb7063b2af7509e43bd84bfc32a4ff71349ec7847713882327b"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/75/d1/eddb559d5911fd889f2ec0de052a88edd0fa8fc4746f29da0d384d29e10e/readchar-4.0.3.tar.gz"
    sha256 "1d920d0e9ab76ec5d42192a68d15af2562663b5dfbf4a67cf9eba520e1ca57e6"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
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
    assert_match "test.svg", shell_output("#{bin}/shallow-backup -show")
  end
end
