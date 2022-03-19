class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/4a/71/5d3cefcf514e2edb468669558092caa8673c352fd798e47cf8a4bb3a1566/virtualenv-20.13.4.tar.gz"
  sha256 "ce8901d3bbf3b90393498187f2d56797a8a452fb2d0d7efc6fd837554d6f679c"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "028d5e5c618d2bdb4a13203d9a001032f4edd1bc9f55496f31f41c163cdd769c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29ce8b7f382f315af3b9ad93c18b7c4e7e95001b5c1569c7fb6a6b7ca5602d16"
    sha256 cellar: :any_skip_relocation, monterey:       "4e5a041a78e31a92adfe4d9dbf9f4bf1b0d368118bc79722ff3f10c2d0fb6f97"
    sha256 cellar: :any_skip_relocation, big_sur:        "85eb71421c4020b224a8da94a30c9624e529e12dfd820d33bca4fab29330986f"
    sha256 cellar: :any_skip_relocation, catalina:       "26089986bc85f243ba225a63f8c16f922d2931e903c1dc0d6f5a3baaafc9c21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e6f417db5b255dd80b6137c088a2e229eeb41a9ab1d83a4343d2a0d7ef195f4"
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
