class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/93/4f/a7737e177ab67c454d7e60d48a5927f16cd05623e9dd888f78183545d250/virtualenv-20.25.1.tar.gz"
  sha256 "e08e13ecdca7a0bd53798f356d5831434afa5b07b93f0abdf0797b7a06ffe197"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce166d1409317827cb154058bb6ba51b16709bd446fcf9db02c3bc27b187c9ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85ea4dd6c2e5feef6da04209e859e949bead8c54ad2fa6fb4979af968150242d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d38548451acc5fb4a5ca7928d968d59866a5883f9aaedb16965af083f462687a"
    sha256 cellar: :any_skip_relocation, sonoma:         "33496628b96c259c9d292836d30f5dd19cce94bbde2a2df919313cf13bf2d92d"
    sha256 cellar: :any_skip_relocation, ventura:        "4228ed0211acbc17a62ca52d0de8cb61eb100965653536a80f5c9d21aa8a5674"
    sha256 cellar: :any_skip_relocation, monterey:       "1227fc3f90895fd0c1b066b7d0d44e5a0e7ce5362a830ea56dd616b2f0c0be0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b448cdaf593688f1b3f615863e6da59fecb8448808dd7c72c5dd8c57f1864fec"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
