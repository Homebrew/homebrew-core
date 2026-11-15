class ScikitImage < Formula
  include Language::Python::Virtualenv

  desc "Image processing in Python"
  homepage "https://scikit-image.org"
  url "https://files.pythonhosted.org/packages/a1/b4/2528bb43c67d48053a7a649a9666432dc307d66ba02e3a6d5c40f46655df/scikit_image-0.26.0.tar.gz"
  sha256 "f5f970ab04efad85c24714321fcc91613fcb64ef2a892a13167df2f3e59199fa"
  license "BSD-3-Clause"
  head "https://github.com/scikit-image/scikit-image.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96d3e25bb4d214ca64001bc26309236a605b708444cdf8d59b04ded274d91403"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf69dbdc8ef6157756a37c2ba6746ca6ac2af13a6f067e606a62537418673c95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e351e9fdedaec1f60926ee273c6dd492f2654d5ef21cbe2a7e496cc3d7baee1"
    sha256 cellar: :any,                 arm64_linux:       "a5aafdeb677c457cf7a19df4b67fa0a1e0c582e708a56e6d7213c5bbe6b33bb3"
    sha256 cellar: :any,                 x86_64_linux:      "41b488addd171fec53c1a75bf1d00df05aa151c69705fffb1e33a955a2838dd8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.15"
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
