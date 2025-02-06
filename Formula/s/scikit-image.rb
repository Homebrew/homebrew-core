class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/83/e5/496a74ccfc1206666b9c7164a16657febdfeb6df0e458cb61286b20102c9/scikit_image-0.25.1.tar.gz"
  sha256 "d4ab30540d114d37c35fe5c837f89b94aaba2a7643afae8354aa353319e9bbbb"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c36e102435c60e49eb073e05d1689017cf2b6f3a2b13a8baa5c5047624b1278"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b39780e17b00ba8e2a74cd575ebaab999542357288c7109f8fee87c93bd6e5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "630e470830b29ea04e07aca484db3f87a51576ee2c61061499b506e23ee5860a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ada55e3b6fb626358951b54f489486ed0dce5ddc91fc49e406b241c0a145caba"
    sha256 cellar: :any_skip_relocation, ventura:       "475146c0cb35a563dacfc909c07273f5ce084bf5010f2850209b72381f98f3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c5c35aa990ee9ee207d1f9d9c0378083b498feab28a821632135feb7b3212a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/0c/47/57e897fb7094afb2d26e8b2e4af9a45c7cf1a405acdeeca001fdf2c98501/imageio-2.37.0.tar.gz"
    sha256 "71b57b3669666272c818497aebba2b4c5f20d5b37c81720e5e1a56d59c492996"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/1d/06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937f/networkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/d5/fc/697d8dac6936a81eda88e7d4653d567fcb0d504efad3fd28f5272f96fcf9/tifffile-2025.1.10.tar.gz"
    sha256 "baaf0a3b87bf7ec375fa1537503353f70497eabe1bdde590f2e41cc0346e612f"
  end

  def install
    virtualenv_install_with_resources
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/skimage/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import skimage as ski
      import numpy

      cat = ski.data.chelsea()
      assert isinstance(cat, numpy.ndarray)
      assert cat.shape == (300, 451, 3)
    PYTHON
    shell_output("#{libexec}/bin/python test.py")
  end
end
