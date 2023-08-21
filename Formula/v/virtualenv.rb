class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/77/f9/f6319b17869e66571966060051894d7a6dc77feceb25a9ebb6daee7eed5a/virtualenv-20.24.3.tar.gz"
  sha256 "e5c3b4ce817b0b328af041506a2a299418c98747c4b1e68cb7527e74ced23efc"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "042e23025f19607b26d8ea0f5d71eb083bbeab66f348d93362e293dbde5f9927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2751c6ec3bf30717b7d9d9f0f30963e487db7f68f5251fe1b962bb2603753910"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce75a2690c48b140813338fb319d189199b6482b06f76c9a085bc2882b250afe"
    sha256 cellar: :any_skip_relocation, ventura:        "5af996737f0e70bed4c58aabe81f842f7434d68c186db93b246d9220d2780074"
    sha256 cellar: :any_skip_relocation, monterey:       "ee95712c29b1e30a4db03aacc8f2fc9d99b583065bcdc507442d9431c0d4fa04"
    sha256 cellar: :any_skip_relocation, big_sur:        "86a55d95680884496a1b29e9fffac6c2310ea3ef970f7b74af4af69f66b3054d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67944c5ac0036d12381f4d8a0e6773908fbbf103fe567166f99be29010e7a955"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/dc/99/c922839819f5d00d78b3a1057b5ceee3123c69b2216e776ddcb5a4c265ff/platformdirs-3.10.0.tar.gz"
    sha256 "b45696dab2d7cc691a3226759c0d3b00c47c8b6e293d96f6436f733303f77f6d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
