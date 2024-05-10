class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/24/ce/183ff64ed397911a9d3b671714f8a2618af407b427a40ca48550fb0f7bd7/scikit_image-0.23.2.tar.gz"
  sha256 "c9da4b2c3117e3e30364a3d14496ee5c72b09eb1a4ab1292b302416faa360590"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "565d50d3357d078e7d35a9eea23f76706906a9b3bf8f7610e93aa2560f70fc44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b28fbc9cd49b7c2ce72a14fc9da5f0201034cfa2f183f05ec343b5a430e5d8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4157c90179ccfc36a400c7843f3f06fbddabb9a0e7551b2df8b70898c26d3698"
    sha256 cellar: :any_skip_relocation, sonoma:         "036f686aa4441fd6c2d3b559734c950297741c6287aceda45580405826d33827"
    sha256 cellar: :any_skip_relocation, ventura:        "1149b14dea7cdc4d7e55f8dd84c8d33ccc43f2ab8b53a91a5e9a4e8bd9aa5d26"
    sha256 cellar: :any_skip_relocation, monterey:       "094aa24d9566672ad6babb7db4cfd9d1af6c76b42921822367e10129c7970bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7569fd80a0416329af9b2cb777f2d621e18ec8b451cc539f2f5acf1afef2d5f"
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
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/04/e6/b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ec/networkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/7b/79/f55cf9d4c2a2bbb19a37d8a0c14142e9c329a6cf3843e8d68237cb0615a8/tifffile-2024.4.18.tar.gz"
    sha256 "5ffcd77b9d77c3aada1278631af5c8ac788438452fda2eb1b9b60d5553e95c82"
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
