class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/4b/12/2337d523dc7085ef0e5a51dfde6059e7969442919aeac8de0064bdb8adb7/scikit_image-0.23.1.tar.gz"
  sha256 "4ff756161821568ed56523f1c4ab9094962ba79e817a9a8e818d9f51d223d669"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9d7fb850f4724eb27f7b0f507d754749b361ed00b52cd120e333a88733315b6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0c43926c13d9a8e91dc4363ce5d0d8f37142f045969f20f14cdc5b335df519a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334a631402e4a35820c3724768575b78529742a357bd50948b60299846d242ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5695331861dbade66f0c0f9c7973df14cdf956684f547d259b5cb8dfee0ddef"
    sha256 cellar: :any_skip_relocation, ventura:        "81e86b9b751949c1c1e34f1bb67a6907835ace4055d37bceff77df645c216481"
    sha256 cellar: :any_skip_relocation, monterey:       "ccdb550f3ed7163230a196c3771d8b282bf9c269474957d527b7f08d4c028120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca6cab7611c3e77019a2ad00a2835a8b535e1730a64899bd7164cbd527b4bf70"
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
