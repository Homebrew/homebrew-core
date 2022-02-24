class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/f1/6d/6c92388af71432c2261476f60c254c3982b6b02f66a33e88a14cc845a8b5/virtualenv-20.13.2.tar.gz"
  sha256 "01f5f80744d24a3743ce61858123488e91cb2dd1d3bdf92adaf1bba39ffdedf0"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "165d03f58847450bba58e6acec45f54b10406bf4150c49498fc742acf5f9b042"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f38cb7a6d8e2feb3a39e57508c6f525857ec8735672d2b512eb285433a77388"
    sha256 cellar: :any_skip_relocation, monterey:       "c5bb7765c52792b1506d1e1210438e3fb969d97a816ba3bef19a4dc80c82f68e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b11be71b4661ef9f943342f74134ad7d10644f2c53bfd009621e823e8e38a3d3"
    sha256 cellar: :any_skip_relocation, catalina:       "08ff864a43f2a18333fa92d83d1be047f2e06c0cf9696371bc95103b10261134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d96f297af0eab67de1678fe902760edc022b0818da493ccebd12cf231fc4c3"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4d/cd/3b1244a19d61c4cf5bd65966eef97e6bc41e51fe84110916f26554d6ac8c/filelock-3.6.0.tar.gz"
    sha256 "9cd540a9352e432c7246a48fe4e8712b10acb1df2ad1f30e8c070b82ae1fed85"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/33/66/61da40aa546141b0d70b37fe6bb4ef1200b4b4cb98849f131b58faa9a5d2/platformdirs-2.5.1.tar.gz"
    sha256 "7535e70dfa32e84d4b34996ea99c5e432fa29a708d0f4e394bbcb2a8faa4f16d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
