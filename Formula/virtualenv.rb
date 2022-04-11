class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/5f/6c/d44c403a54ceb4ec5179d1a963c69887d30dc5b300529ce67c05b4f16212/virtualenv-20.14.1.tar.gz"
  sha256 "ef589a79795589aada0c1c5b319486797c03b67ac3984c48c669c0e4f50df3a5"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8345fdd7e3be051c84e93519befbed4726b91a919c8734b68426cb92e4995d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e872f10d76ca8688bc470bd626ef88ad1e5f8c03ccb466eaacfb456f10cee66"
    sha256 cellar: :any_skip_relocation, monterey:       "5d1395c85f34afdbc2b56d875f0deecf65f7199d4d5fc0bfb031fb9573299213"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bd93388e695bd790889d3477f02dd10f200af4a03ef52da41eb3830d371f6d9"
    sha256 cellar: :any_skip_relocation, catalina:       "f9b4c57c175765f3c739e33712741979ff2de6d9092addb4479c7b5f0201818c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38f5c4383dce1fd2aca8bfdcacf68fd72c27dd2130caa7f7338922f7fcda53a2"
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
