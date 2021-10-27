class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/8b/67/67e5dd2d1676c3fa8a67c707114325d713feadb7824d9aaf2396be5401d3/virtualenv-20.9.0.tar.gz"
  sha256 "bb55ace18de14593947354e5e6cd1be75fb32c3329651da62e92bf5d0aab7213"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abba1a14d00ad48e7d1e186ae8b3e3d8eb4bd9eb8b9c2b83ea4236dcf0322ee6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9e58f0b830add292d7d7717ba20c733f7eb756cc8c53d0cc26f81b2756984d8"
    sha256 cellar: :any_skip_relocation, monterey:       "541f49880767f1c2b7d5047335e651b6c80470f423fe27d25f45bf444b65a051"
    sha256 cellar: :any_skip_relocation, big_sur:        "8afe6ca5f0c8edcc5167c14b109eb73775a5b51fc823c3b974eb5fa12d795ddb"
    sha256 cellar: :any_skip_relocation, catalina:       "cb0f19e67d3b25a3f2abaf58b4be2ef937fb79697f34e1c6d052617e180100ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ed5e39e8a37376706f84e07bb887e3968c619033d3e40a7b7c4a1ff611fdef"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/8f/eb/6faad9294c8a8d59b7599a8a7c669c0e4c317fa5012bc36f1c8b379972a5/filelock-3.3.1.tar.gz"
    sha256 "34a9f35f95c441e7b38209775d6e0337f9a3759f3565f6c5798f19618527c76f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
