class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/a1/b4/2528bb43c67d48053a7a649a9666432dc307d66ba02e3a6d5c40f46655df/scikit_image-0.26.0.tar.gz"
  sha256 "f5f970ab04efad85c24714321fcc91613fcb64ef2a892a13167df2f3e59199fa"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92362bb9e8915f4663e1128f494955d8b2b9c2696ee10f6dcc8847e18dd3b4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf3ccc5a82af9515777cba387b399b8df00dab47b5718c0dbdbcfd7db628cb20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "359b8d85b12902b35a37b340e59071a2ee973968dc142ced86417280d3e180a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4022877af97831db0e3a4c01055c1fb7911489a549a7a78c52bf51097d6c1c4"
    sha256                               arm64_linux:   "f0c666448141861405ba8619e1d8c9f0e4fc0b3837a26ff62a5cfcf5b347691a"
    sha256                               x86_64_linux:  "50f382f378a0ffc746827a9626da66979d0cd47db10be2647e50c2272b4b5ad7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "scipy"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[numpy pillow scipy]

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/a3/6f/606be632e37bf8d05b253e8626c2291d74c691ddc7bcdf7d6aaf33b32f6a/imageio-2.37.2.tar.gz"
    sha256 "0212ef2727ac9caa5ca4b2c75ae89454312f440a756fcfc8ef1993e718f50f8a"
  end

  resource "lazy-loader" do
    url "https://files.pythonhosted.org/packages/6f/6b/c875b30a1ba490860c93da4cabf479e03f584eba06fe5963f6f6644653d8/lazy_loader-0.4.tar.gz"
    sha256 "47c75182589b91a4e1a85a136c074285a5ad4d9f39c63e0d7fb76391c4574cd1"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/6a/51/63fe664f3908c97be9d2e4f1158eb633317598cfa6e1fc14af5383f17512/networkx-3.6.1.tar.gz"
    sha256 "26b7c357accc0c8cde558ad486283728b65b6a95d85ee1cd66bafab4c8168509"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "tifffile" do
    url "https://files.pythonhosted.org/packages/31/b9/4253513a66f0a836ec3a5104266cf73f7812bfbbcda9d87d8c0e93b28293/tifffile-2025.12.12.tar.gz"
    sha256 "97e11fd6b1d8dc971896a098c841d9cd4e6eb958ac040dd6fb8b332c3f7288b6"
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
