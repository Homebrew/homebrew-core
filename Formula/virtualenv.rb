class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/8b/67/67e5dd2d1676c3fa8a67c707114325d713feadb7824d9aaf2396be5401d3/virtualenv-20.9.0.tar.gz"
  sha256 "bb55ace18de14593947354e5e6cd1be75fb32c3329651da62e92bf5d0aab7213"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e659915b212684ff5d84ce94d848786d5874ffb7e1ed7560da4fd3fac3674cca"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c54a6d3ac95608ab985ee2ca8b117fbbc8dd3aed52f38e345018b5e3e6abb9a"
    sha256 cellar: :any_skip_relocation, catalina:      "80d844e7b609a95ecc08dc109b0d0790be2aca4df652ffac91cf6019fa2d7c94"
    sha256 cellar: :any_skip_relocation, mojave:        "ba954bcf37996ebf410f1f3614e06f1854f8b839c7207428a8803cde69a32c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "045897f9a95b6714d338382ebed98a55f167aca2d8d8b6513f5521d388045cfb"
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
