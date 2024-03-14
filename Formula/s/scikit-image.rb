class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/65/c1/a49da20845f0f0e1afbb1c2586d406dc0acb84c26ae293bad6d7e7f718bc/scikit_image-0.22.0.tar.gz"
  sha256 "018d734df1d2da2719087d15f679d19285fce97cd37695103deadfaef2873236"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd1db9cce79197508fccbc39747ea3e73a32fde20570f1b04a5976afa473153a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36bbb80bdcbd7006c8ac5cf455362e2a5ab3d6db2681c2d6798f2b8b969b6ff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "783d14ad0663ef04049ad0d86608a00c1ae67d9c825ae79561e0cb558b717006"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b4449ac4a1df85ad8bde5e4e716d501c787c7f77669da51217b26c69f850027"
    sha256 cellar: :any_skip_relocation, ventura:        "56fe3cb6085942201e15a9fe4cddc2a9d4c683c222cb4a800f6ad7e9577d5090"
    sha256 cellar: :any_skip_relocation, monterey:       "576a0b7dc7e672b1e4c8248da9ef438a88059c8bad81d085bf0065b9bb71e469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67288d99340a9f0aabc28585a3f5808346eb2574cd6330d190a8317152bdc903"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/c3/71/70f81a9c0cd3b106f6663af8d92402d16354abec48f7b8ba15a6c41ddca9/imageio-2.34.0.tar.gz"
    sha256 "ae9732e10acf807a22c389aef193f42215718e16bd06eed0c5bb57e1034a4d53"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/0e/3a/1630a735bfdf9eb857a3b9a53317a1e1658ea97a1b4b39dcb0f71dae81f8/lazy_loader-0.3.tar.gz"
    sha256 "3b68898e34f5b2a29daaaac172c6555512d0f32074f147e2254e4a6d9d838f37"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/d1/54/e627e6604700d5ec694b023ae971a5493560452fe062d057dba1db23ac82/tifffile-2024.2.12.tar.gz"
    sha256 "4920a3ec8e8e003e673d3c6531863c99eedd570d1b8b7e141c072ed78ff8030d"
  end

  def install
    virtualenv_install_with_resources
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/skimage/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    EOS
    shell_output("#{libexec}/bin/python test.py")
  end
end
