class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/74/65/ec1d92091671e6407d3e7c1f5801413bb7b2b57630a50cae7750456ba0ed/virtualenv-21.6.0.tar.gz"
  sha256 "e18a4d750f2b64dea73e72ffde3922f3c52365fabdc8157ebd3da20d031c4734"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "90a5b58f3ce6ab838c7ec197946aef165a514c0c99f4677777858aef01937c5c"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/e0/c8/35bdf04fb30755e2ed758f877edf3eb4a243c2463d3a258cc28b18b7a6e2/filelock-3.29.6.tar.gz"
    sha256 "895c532ef3f4ef04972b9446a8c4e2931a5c399ff3c4be4c9369f2639b80f793"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/66/26/8b004cc36f430345136f6f00fa1aa9ed596c8ed1e8504625fa79522ff39c/python_discovery-1.4.3.tar.gz"
    sha256 "ad57d7045a862460d4a235986c33f13ed707d3aeb9153fa47eb7dfd0d4673289"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
