class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/2f/5d/42254e91a9203a13d95ab4f5211f4cdda52b82fc3546340f7fb33a642173/virtualenv-21.9.0.tar.gz"
  sha256 "fa0f2a26fcb6f32b376fc8b2c705b6057366763d5b9e5242d1ab10ecc3279fd3"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88268c336ec43ee6cde4d660e3361e3a1178cd9d6cb886032a929fdf2dba2541"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db8717a1bd4f7a1dc7f4b6e182d2c4f3ede46ddd8fe5156b800f22ebc03c75d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b952f48f945ae4d1b16e6a9ce8d76cdbfccb58fd84fc96fc59418c6c77f53793"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e52a3a3a13e00ab068fe1a2317b3803eb7220ffaefa6972d668d300ff895b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b007f55521e307975a6bc10b8d1f930b696f8d7c1e689c5eb3f55fa36b826559"
  end

  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0f/59/e19834834cb01a32febfbb0f8a23a9088088f5d45991824ff2bc3b5e8acb/filelock-3.32.7.tar.gz"
    sha256 "37b8a3d9811b0f9aef7e5ec5c71bb320de52df51e6ca9bcd6f5ad81187660da7"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f8/13/f870dd0b42690138e4e37a76b5138e5690ed4365a77071bb092d59037da0/platformdirs-4.11.11.tar.gz"
    sha256 "b0befe8a90759e4a9a8b9820d434ae226a6549063210b596da0038a7a05aede4"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/0c/57/250bd238b966cece44328235eb85290045d059265fdaf7527a3a958123db/python_discovery-1.6.1.tar.gz"
    sha256 "cf87d3627dfb4412437fdd5b13eae402607722998d21567993aedbc59b23c15e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
