class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/a6/8e/2ebdf99a0dd15249272780e34fa40e3becfd28689505979d3ec6aa2f6ce1/virtualenv-20.24.4.tar.gz"
  sha256 "772b05bfda7ed3b8ecd16021ca9716273ad9f4467c801f27e83ac73430246dca"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a73643861e0cccf2261de0367a33d51c3d3a7aaf4316e346627bde4dd2b1921f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8ff35baf2734a86876d666ea7eb4572b72cf901517598ef315f0d3b6cfbb18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b80593489685dfa6efa987f8395b20ceae92899bdd66172ddba4984c602f5e78"
    sha256 cellar: :any_skip_relocation, ventura:        "3eff9ad44cd492b0fa2e2b352d622b438c6d42b734628937e6f82942cc2c63fe"
    sha256 cellar: :any_skip_relocation, monterey:       "76c292eeafdf347bd33d894fc0df16be7d12fc0c39347194ddc4b264fe2db24c"
    sha256 cellar: :any_skip_relocation, big_sur:        "52c47837fa96e94c26429884d7ff08bde8f3bf2a67320dd9b7ab99577f82fcdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96c293e65e651708f507a45dd9dbaa3a5c3f360660ddfa4646975b23be2c929e"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/5a/47/f1f3f5b6da710d5a7178a7f8484d9b86b75ee596fb4fefefb50e8dd2205a/filelock-3.12.3.tar.gz"
    sha256 "0ecc1dd2ec4672a10c8550a8182f1bd0c0a5088470ecd5a125e45f49472fac3d"
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
