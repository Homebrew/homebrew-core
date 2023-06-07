class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/d6/37/3ff25b2ad0d51cfd752dc68ee0ad4387f058a5ceba4d89b47ac478de3f59/virtualenv-20.23.0.tar.gz"
  sha256 "a85caa554ced0c0afbd0d638e7e2d7b5f92d23478d05d17a76daeac8f279f924"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef550c9f63eb3a337ba64c12690a17db6a93696afd97e3013c2ddcccb842444e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd8ebd290416b607115307adac76018a79b21e6b39aec7aaace681a623c0176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f803cafcce59e447e90f1e5610b9d0a47ab07768ef69e4cf2dd47ff68dd1b55b"
    sha256 cellar: :any_skip_relocation, ventura:        "e65c19280f0b5b789f4b01e373b47e9b3963d84572cb4ff489b45da952cb348e"
    sha256 cellar: :any_skip_relocation, monterey:       "f998b93c768551d582a4fb6d676b58b03791bbad5ba760937a2c72ebe7d37679"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb80e2e5a44c751529025f76e720e5750c934e17bfb3b692f1a67d9e823ccdc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77c60455211f78535f7a87eb374b5010e52f5701f35af4e71b85ca19c02b5ef"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/91/17/3836ffe140abb245726d0e21c5b9b984e2569e7027c20d12e969ec69bd8a/platformdirs-3.5.0.tar.gz"
    sha256 "7954a68d0ba23558d753f73437c55f89027cf8f5108c19844d4b82e5af396335"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
