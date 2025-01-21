class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/e6/8d/383e5438c807804b66d68ed2c09202d185ea781b6022aa8b9fac3851137f/scikit_image-0.25.0.tar.gz"
  sha256 "58d94fea11b6b3306b3770417dc1cbca7fa9bcbd6a13945d7910399c88c2018c"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b2303edcfb1969d77574f243a4b5f555974ab15368fa79db9697b6e13992e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8c883b913a8780584bd5aede7d29c3bb5de3c55142514a21b72400ff934c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5022142503ff01c444be638e0ff96d631a5d8ff29e069f47e451f2cccd287e92"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d49c28eb656507cb459b501461640699ba1fcf3b04824c288c65782edcfe0ff"
    sha256 cellar: :any_skip_relocation, ventura:       "4848b545c08b8f87049eceb3edc3d8a2639887ee29446da57d0d57474a3fad5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c5eb3a8bb62c0363390b80572ff1d53145ab32088c3dc190b352f8b6543ee3"
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
    url "https://files.pythonhosted.org/packages/70/aa/2e7a49259339e691ff2b477ae0696b1784a09313c5872700bbbdd00a3030/imageio-2.36.1.tar.gz"
    sha256 "e4e1d231f47f9a9e16100b0f7ce1a86e8856fb4d1c0fa2c4365a316f1746be62"
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
    url "https://files.pythonhosted.org/packages/37/c9/fc4e490c5b0ccad68c98ea1d6e0f409bd7d50e2e8fc30a0725594d3104ff/tifffile-2024.12.12.tar.gz"
    sha256 "c38e929bf74c04b6c8708d87f16b32c85c6d7c2514b99559ea3db8003ba4edda"
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
