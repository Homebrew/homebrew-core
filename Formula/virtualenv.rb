class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/4a/c3/04f361a90ed4e6b3f3f696d61db5c786eaa741d2a6c125bc905b8a1c0200/virtualenv-20.14.0.tar.gz"
  sha256 "8e5b402037287126e81ccde9432b95a8be5b19d36584f64957060a3488c11ca8"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fbeee76c0744ec51af91de0c1e2f4eaba34d69fb0ce713e953ec92708de5e79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38dc44e0e3df016c023799452184b59c53ba029d7a85f55878cacefa9c20ed30"
    sha256 cellar: :any_skip_relocation, monterey:       "8ee584825f9069f91b31f85cd2b62522800a0006f917c99b5dc42f1ec01972fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "661eff38e44f7e95d6fffb72fa7c15379734acbab366d224364f138ae9619c63"
    sha256 cellar: :any_skip_relocation, catalina:       "f943d813f37605a6cb0d3cd9b9c8669b085d0f1c60c005ffc42fd6172f2cc537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "905b1146b830d629dc62d4b2e74b336ccb75dcb27083c7c1090dec5a5df46c11"
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
